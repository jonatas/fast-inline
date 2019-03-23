# frozen_string_literal: true

require 'fast/inline/version'
require 'fast'

def simple(node)
  node.children.size == 1
end

module Fast
  module Inline
    module_function

    def local_variable(code)
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
      Fast.replace(ast, '(lvar _)', replacement)
    end

    def method_def(code)
      ast = Fast.ast(code)
      methods = Fast.search(ast, '(def _ (args) )')
      method_names = methods.map { |n| n.children[0] }
      method_usages = "(send nil { #{method_names.join(' ')} })"

      replacement = proc do |*usages|
        usages.each do |usage|
          def_node = Fast.search(ast, "(def #{usage.children[1]} (args) ...)").first
          def_body = def_node.children.last
          source = def_body.loc.expression.source

          remove(def_node.loc.expression)
          replace(usage.loc.expression, source)
        end
      end

      output = Fast.replace(ast, method_usages, replacement)
      ast = Fast.ast(code)

      usages = Fast.search(ast, method_usages)
      args = Fast.capture(ast, '(args (arg $_))')
      args = [*args]

      arguments_bind = [usages.first.children.last]
      params_inline = args.each_with_object({}) do |arg, h|
        h[arg] = arguments_bind.shift.loc.expression.source
      end
      arg_usage = Fast.search(ast, "(lvar { #{args.join(' ')}  })")
      arg_usage.each do |arg_call|
        arg_name = arg_call.children.last
        output.gsub!(arg_call.loc.expression.source, params_inline[arg_name])
      end
      output
    end
  end
end
