module GrapeDoc
  class ApiDocParts

    class H1 < StringObject
    end

    class H2 < H1
    end

    class H3 < H1
    end

    class H4 < H1
    end

    class H5 < H1
    end

    class H6 < H1
    end

    class Block < StringObject
      self.markdown = "bq"
    end

    class Br < StringBasic
    end

  end
end