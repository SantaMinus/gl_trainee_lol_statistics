require 'test_helper'

class BannedChampionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @banned_champion = banned_champions(:one)
  end

  test "should get index" do
    get banned_champions_url
    assert_response :success
  end

  test "should get new" do
    get new_banned_champion_url
    assert_response :success
  end

  test "should create banned_champion" do
    assert_difference('BannedChampion.count') do
      post banned_champions_url, params: { banned_champion: { champion_id: @banned_champion.champion_id, pick_turn: @banned_champion.pick_turn, team_id: @banned_champion.team_id } }
    end

    assert_redirected_to banned_champion_url(BannedChampion.last)
  end

  test "should show banned_champion" do
    get banned_champion_url(@banned_champion)
    assert_response :success
  end

  test "should get edit" do
    get edit_banned_champion_url(@banned_champion)
    assert_response :success
  end

  test "should update banned_champion" do
    patch banned_champion_url(@banned_champion), params: { banned_champion: { champion_id: @banned_champion.champion_id, pick_turn: @banned_champion.pick_turn, team_id: @banned_champion.team_id } }
    assert_redirected_to banned_champion_url(@banned_champion)
  end

  test "should destroy banned_champion" do
    assert_difference('BannedChampion.count', -1) do
      delete banned_champion_url(@banned_champion)
    end

    assert_redirected_to banned_champions_url
  end
end
