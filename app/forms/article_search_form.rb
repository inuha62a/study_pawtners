class ArticleSearchForm
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :keyword, :string
    attribute :category, :string

    def search(params = {})
      scope = Article.distinct  # ← これで解決！
  
      if keyword.present?
        scope = scope
          .left_outer_joins(:comments)  # ← コメントと外部結合
          .where(
            "articles.title LIKE :kw OR comments.body LIKE :kw",
            kw: "%#{keyword}%"
          )
          .distinct  # ← 実はここは不要になります
      end

      scope = scope.where(category: category) if category.present?
      scope
    end
end
