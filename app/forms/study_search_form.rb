class StudySearchForm
    include ActiveModel::Model
    attr_accessor :from, :to, :keyword

    def search(user)
      studies = user.study_records # モデル名に応じて変更
      studies = studies.where("date >= ?", from) if from.present?
      studies = studies.where("date <= ?", to) if to.present?

      if keyword.present?
        studies = studies.left_joins(:learning_items).where("study_records.body LIKE ? OR learning_items.name LIKE ? ", "%#{keyword}%", "%#{keyword}%")
      end

      studies.distinct
    end
end
