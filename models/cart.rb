require_relative './base'

module Models
  class Cart < Models::Base
    include Helpers::ProductsHelper

    attr_reader :products

    # @param product_uids [Array<String>] An array of Product#uids
    #
    def initialize(product_uids:)
      @products = group_by_product_uid(product_uids)
    end

  private

    def group_by_product_uid(product_uids)
      product_uids
        .group_by { |uid| uid }
        .transform_keys { |uid| uid.to_sym }
        .transform_values { |uids| { quantity: uids.size } }
    end
  end
end
