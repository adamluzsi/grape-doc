module GrapeDoc
  class ApiDocumentation

    class List < ArrayObject
      self.markdown = '*'
    end

    class NumericalList < ArrayObject
      self.markdown = '#'
    end

  end
end