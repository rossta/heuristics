module Emergency

  class Ambulance
    include Positioning
    include ActsAsNamed

    LOAD_TIME   = 1
    UNLOAD_TIME = 1
    MAX_LOAD    = 4

    attr_accessor :time, :patients, :hospital

    def self.next
      return nil if !all.any?(&:available?)
      ambulance = nil
      while ambulance.nil?
        i = rand(all.size)
        ambulance = all.detect { |a| all.index(a) == i && a.available? }
      end
      ambulance
    end

    def initialize(hospital)
      @hospital = hospital
    end

    def reset
      @position = @hospital.position
      @time = 0
      @patients = []
      @log = []
      @available = true
    end

    def save_all(people)
      while person = next_saveable(people)
        pickup person

        while @patients.size < MAX_LOAD do
          person = next_saveable(people)
          break if person.nil?
          if time_to_save_person(person) < time_left_for_patients?
            pickup person
          else
            break
          end
        end

        unload
      end
      @available = false
    end

    def time_left_for_patients?
      return 10000000 if @patients.empty?
      @patients.map{ |p| p.time_left(time) }.min
    end

    def next_saveable(people)
      people.select { |p|
          p.alive?(time) && !p.dropped? && !patient?(p) && time_to_save_person(p) <= p.time_left(time)
        }.sort { |p1, p2|
          viability(p1) <=> viability(p2)
        }.first
    end

    def rand_next_saveable(people)
      saveable = people.select { |p|
        p.alive?(time) && !p.dropped? && !patient?(p) && time_to_save_person(p) <= p.time_left(time)
      }.sort { |p1, p2|
        total = (pheromability(p1) + pheromability(p2)).to_i
        ((rand(total)) < pheromability(p2)) ? -1 : 1
      }.first
    end

    def available?
      @available
    end

    def pickup(person)
      tick distance_to(person) + LOAD_TIME
      @position = person.position
      @patients << person
      Logger.record "#{display_name} #{person.display_name}"
    end

    def unload
      hospital = nearest(Hospital.all)
      tick distance_to(hospital) + UNLOAD_TIME
      @position = hospital.position
      @patients.each { |p| p.drop_at(hospital) }
      Logger.record "#{display_name} (#{hospital.to_coord.join(',')})"
      @patients = []
    end

    def time_to_save_person(person)
      distance_to(person) + LOAD_TIME + person.hospital_distance + UNLOAD_TIME
    end

    def viability(person)
      distance_to(person) * person.time_left(time)
    end

    def pheromability(person)
      distance_to(person) * person.time_left(time) * (rand(person.pherome + 1))
    end

    def patient?(person)
      @patients.include? person
    end

    def display_name
      "Ambulance #{name}"
    end

    def tick(time)
      @time += time
    end

  end

end