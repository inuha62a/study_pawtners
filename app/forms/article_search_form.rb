class ArticleSearchForm
    include ActiveModel::Model
    # include ActiveModel::Attributes

    attr_accessor :keyword, :category
    # attribute :keyword, :string
    # attribute :category, :string

    def search(current_user)
      scope = current_user.articles.distinct  # ← ユーザーの記事のみ
      # keywordやcategoryでの絞り込み処理

      if keyword.present?
        scope = scope
          .left_outer_joins(:comments)  # ← コメントと外部結合
          .where(
            "articles.title LIKE :kw OR comments.body LIKE :kw",
            kw: "%#{keyword}%"
          )
      end

      scope = scope.where(category: category) if category.present?
      scope
    end
end
