class ReportsController < ApplicationController

  def show
    @test = Test.friendly.find(params[:id])
    @questions = @test.questions
    @respondents = @test.questions[0].answers.where(test_id: @test.id).count
    @library = {xtitle: 'Average response', hAxis: {ticks: [1,2,3,4,5]},
                chartArea: {left: 400, width: 500}}
  end


  private

  def test_params
    params.require(:test).permit(:name, :test_url, :test_type_id, :question_ids => [])
  end


end
