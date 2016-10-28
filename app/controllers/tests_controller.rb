class TestsController < ApplicationController

  def new
    if user_signed_in?
      @test = Test.new
      @test_types = TestType.all
      @questions = Question.all
    else
      redirect_to new_user_registration_path
    end
  end

  def create
    @test = Test.new(test_params)
    if @test.save
      @test.update(slug: @test.name.downcase)
      redirect_to thanks_test_path(@test)
    else
      flash[:error] = @test.errors.full_messages.map{|o| o  }.join("")
      redirect_to new_test_path
    end
  end

  def show
    @test = Test.friendly.find(params[:id])
    @questions = @test.questions
  end

  def thanks
    @test = Test.friendly.find(params[:id])
  end

  private

  def test_params
    params.require(:test).permit(:name, :test_url, :test_type_id, :question_ids => [])
  end

end
