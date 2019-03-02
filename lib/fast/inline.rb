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
      replacement = proc do |*nodes|
        nodes.each do |usage|
          variable_name, = usage.children
          lvar_node = Fast.capture(ast, "$(lvasgn #{variable_name})")
          source = lvar_node.children.last.loc.expression.source
          replace(usage.loc.expression, source)
          remove(lvar_node.loc.expression)
        end
      end
      Fast.replace(ast, "(lvar _)", replacement)
    end
  end
end
