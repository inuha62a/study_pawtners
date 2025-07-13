class CreateStudyRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :study_records do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.text :body

      t.timestamps
    end

    # ここに複合ユニーク制約を追加
    add_index :study_records, [ :user_id, :date ], unique: true
  end
end
