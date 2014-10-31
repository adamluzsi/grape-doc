module GrapeDoc
  class ApiDocumentation

    class Sidebar < StringObject
      def to_textile
        [
            '<div style="float:right;">',
            self.to_s,
            '</div>'
        ].join("\n")
      end
    end

  end
end