# coding: utf-8
class AskSuggestTopic
  include Mongoid::Document

  belongs_to :ask
  field :topics, :type => Array, :default => []

  def self.find_by_ask(ask)
    return [] if !ask.topics.blank?
    item = self.find_or_initialize_by(:ask_id => ask.id)
    return item.topics if !item.topics.blank?

    # 生成内容
    words = ask.title
    topics = Topic.any_in(:name => words)


    item.save
    return item.topics
  end
end
