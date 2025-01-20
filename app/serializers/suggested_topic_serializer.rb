# frozen_string_literal: true

class SuggestedTopicSerializer < ListableTopicSerializer
  include TopicTagsMixin

  # need to embed so we have users
  # front page json gets away without embedding
  class SuggestedPosterSerializer < ApplicationSerializer
    attributes :extras, :description
    has_one :user, serializer: PosterSerializer, embed: :objects
  end

  attributes :archetype,
             :like_count,
             :views,
             :category_id,
             :featured_link,
             :featured_link_root_domain,
             :category,
             :topic_creator
  has_many :posters, serializer: SuggestedPosterSerializer, embed: :objects

  def posters
    object.posters || []
  end

  def include_featured_link?
    SiteSetting.topic_featured_link_enabled
  end

  def featured_link
    object.featured_link
  end

  def include_featured_link_root_domain?
    SiteSetting.topic_featured_link_enabled && object.featured_link
  end

  def category
    {
      id: object.category.id,
      name: object.category.name,
      topic_title: object.title,
      only_admin_can_post: object.category.groups.exists?(name: "admins")
    }
  end

  def topic_creator
    {
      id: object.user&.id,
      username: object.user&.username,
      name: object.user&.name,
      avatar: object.user&.avatar_template
    }
  end
end