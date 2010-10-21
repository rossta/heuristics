module Emergency

  class Hospital
    include Positioning
    include ActsAsNamed

    def self.all
      @@all
    end

    def self.all=(all)
      @@all = all
    end

    attr_accessor :ambulances, :name

    def initialize(count)
      @ambulances = []
      count.times do |i|
        @ambulances << Ambulance.new
      end
    end

    def assign_ambulance_positions
      @ambulances.each do |a|
        a.position = position
      end
    end

  end

  class Ambulance
    include Positioning
    include ActsAsNamed

    LOAD_TIME   = 1
    UNLOAD_TIME = 1
    MAX_LOAD    = 4

    attr_accessor :time, :patients

    def initialize
      @time = 0
      @patients = []
    end

    def travel(people)
      puts "People needing saving: #{Person.all.size - Person.saved.size}"
      puts "Ambulance #{name} at #{self.to_coord.join(', ')}"
      Clock.reset
      while person = next_saveable(people)
        # find 'best' person
        pickup person

        while @patients.size < MAX_LOAD do
          person = next_saveable(people)
          break if person.nil?
          if time_to_save_person(person) < @patients.map(&:time_left).min
            pickup person
          else
            break
          end
        end

        unload
        puts "Time    : #{Clock.time}"
      end

      @time = Clock.time
    end

    def next_saveable(people)
      people.select { |p|
          p.alive? && !p.saved?
        }.select { |p|
          time_to_save_person(p) >= p.time_left
        }.sort { |p1, p2|
          viability(p1) <=> viability(p2)
        }.first
    end

    def pickup(person)
      Clock.tick(distance_to(person) + LOAD_TIME)
      self.position = person.position
      @patients << person
      self.time = Clock.time
      puts "- pick up   #{person.name}  at #{person.to_coord.join(', ')}"
    end

    def unload
      hospital = nearest(Hospital.all)
      Clock.tick(distance_to(hospital) + UNLOAD_TIME)
      self.position = hospital.position
      @patients.each { |p| p.drop_at(hospital) }
      puts "- drop off  #{@patients.map(&:name).join(", ")}     at #{hospital.to_coord.join(', ')}"
      @patients = []
    end

    def time_to_save_person(person)
      distance_to(person) + LOAD_TIME + person.hospital_distance + UNLOAD_TIME
    end

    def viability(person)
      distance_to(person) * person.time_left
    end

  end

end