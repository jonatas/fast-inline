require "fast/inline/version"
require "fast"

def simple(node)
  node.children.size == 1
end

module Fast
  module Inline
    module_function
    def local_variable code
      ast = Fast.ast(code)
      lvars = *Fast.capture(ast, "$(lvasgn _ #simple")

      replacement = proc do |*nodes|
        nodes.each do |usage|
          variable_name, = usage.children
          lvar_node = Fast.capture(ast, "$(lvasgn #{variable_name})")
          if index = lvars.index(variable_name)
            source = lvars[index+1].loc.expression.source
            replace(usage.loc.expression, source)
            remove(lvar_node.loc.expression)
          end
        end
      end
      Fast.replace(ast, "(lvar _)", replacement)
    end
  end
end
