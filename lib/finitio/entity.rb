module Finitio
  class Entity < Module

    class ClassLevel < Module

      def initialize(infotype)
        install_dress_method(infotype)
        infotype.contracts.each do |contract|
          install_contract(contract)
        end
      end

      def install_contract(contract)
        define_method(contract.name) do |*args, &bl|
          new(*args, &bl)
        end
      end

      def install_dress_method(infotype)
        define_method(:dress) do |from|
          infotype.dress(from)
        end
      end

    end # ClassLevel

    class InstanceLevel < Module

      def initialize(infotype)
        define_initialize(infotype)
        infotype.contracts.each do |contract|
          install_contract(contract)
          install_accessors(contract)
        end
      end

      def define_initialize(infotype)
        define_method :initialize do |info|
          info.each_pair do |k,v|
            send(:"#{k}=", v)
          end
        end
      end

      def install_contract(contract)
        this = self
        define_method :"to_#{contract.name}" do
          info = {}
          this.each_attribute(contract) do |attrname,_|
            info[attrname] = self.send(:"#{attrname}")
          end
          info
        end
      end

      def install_accessors(contract)
        each_attribute(contract) do |attrname,_|
          attr_accessor attrname
          protected :"#{attrname}="
        end
      end

      def each_attribute(contract)
        infotype = contract.infotype
        raise "Heading-based expected" unless infotype.respond_to?(:heading)
        infotype.heading.each do |attribute|
          yield(attribute.name)
        end
      end
    
    end # module InstanceLevel

    def initialize(system)
      @system = system
    end
    attr_reader :system

    def included(by)
      super
      install_includer(by)
    end

    def install_includer(by)
      name = by.name.to_s[/::(.*?)$/, 1]
      type = system[name]

      # Extend the class level
      by.extend(ClassLevel.new(type))

      # Extend the instance level
      by.instance_eval {
        include(InstanceLevel.new(type))
      }

      # Set the ruby type of the ADT
      type.ruby_type = by
    end

  end # class Entity

  def self.entity_builder(system)
    Entity.new(system)
  end

end # module Finitio
