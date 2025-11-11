module Pra
  module Template
    # 汎用テキストテンプレートエンジン
    # Markdownやその他のテキストファイル向けのフォールバック
    # プレースホルダ形式: {{VARIABLE_NAME}}
    class StringTemplateEngine
      def initialize(template_path, variables)
        @template_path = template_path
        @variables = variables
      end

      # テンプレートをレンダリングして結果の文字列を返す
      #
      # @return [String] レンダリング後の文字列
      def render
        source = File.read(@template_path, encoding: "UTF-8")

        # {{VAR_NAME}} パターンのプレースホルダを置換
        @variables.each do |key, value|
          placeholder = "{{#{key.to_s.upcase}}}"
          source.gsub!(placeholder, value.to_s)
        end

        source
      end
    end
  end
end
