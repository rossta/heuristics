module Emergency

  module ActsAsNamed

    module ClassMethods; end

    def self.included(base)
      base.class_eval {
        attr_accessor :name
      }
      base.extend ClassMethods
      base.acts_as_named
    end

    module ClassMethods

      def acts_as_named
        @instance_count = 0
      end

      def new(*args)
        instance = super(*args)
        instance.name = @instance_count
        @instance_count += 1
        instance
      end

      def all
        @all
      end

      def all=(all)
        @all = all
      end

    end

  end

end
