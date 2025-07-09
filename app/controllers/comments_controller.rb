class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_article
    before_action :set_comment, only: [ :edit, :update, :destroy ]
    before_action :correct_user!, only: [ :edit, :update, :destroy ]

    def create
      unless @article.user == current_user
        redirect_to @article, alert: "コメントできるのは記事作成者のみです"
        return
      end
    
      # ▼ 日付から学習記録を探す or 作成
      study_date = params[:comment][:study_record_date]
      @study_record = current_user.study_records.find_or_create_by(date: study_date) do |sr|
        sr.body = "" # 新しく作るときだけ空の本文で
      end
    
      @comment = @article.comments.build(comment_params)
      @comment.user = current_user
      @comment.study_record = @study_record
      @comment.tag = Array(params[:comment][:tag])
    
      if @comment.save
        redirect_to @article, notice: "コメントを追加しました"
      else
        flash.now[:alert] = "コメントの投稿に失敗しました"
        render "articles/show", status: :unprocessable_entity
      end
    end

    def edit
      # Turboが自動でeditビューをレンダリング
    end

    def update
      @article = @comment.article

      if @comment.update(comment_params)
        respond_to do |format|
          format.turbo_stream
          format.html { redirect_to article_path(@article), notice: "コメントを更新しました。" }
        end
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace(@comment, partial: "comments/form", locals: { comment: @comment }) }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @comment.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @article, notice: "コメントを削除しました" }
      end
    end

    private

    def set_article
      @article = Article.find(params[:article_id])
    end

    def set_comment
      @comment = @article.comments.find(params[:id])
    end

    def correct_user!
      unless @comment.user == current_user
        redirect_to article_path(@article), alert: "アクセス権がありません"
      end
    end

    def comment_params
      params.require(:comment).permit(:body, :image, tag: [])
    end
end
