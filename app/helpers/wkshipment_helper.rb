module WkshipmentHelper
  include WktimeHelper
  include WkcrmHelper
	
	def product_item_select(sqlCond, needBlank, selectedVal)
		ddArray = getProductItemArr(sqlCond, needBlank)		
		options_for_select(ddArray, :selected => selectedVal)
	end
	
	def getProductItemArr(sqlCond, needBlank)
		ddArray = Array.new
		if sqlCond.blank?
			ddValues = WkProductItem.includes(:brand, :product_model).all 
		else
			ddValues = WkProductItem.where("#{sqlCond}")
		end
		unless ddValues.blank?
			ddArray = ddValues.collect {|t| [(t.brand.blank? ? '' : t.brand.name.to_s) + ' - ' + (t.product_model.blank? ? '' : t.product_model.name.to_s) , t.id] }
		end
		ddArray.unshift(["",""]) if needBlank
		ddArray
	end
	
	def isUsedInventoryItem(invenItem)
		ret = false
		if invenItem.available_quantity != invenItem.total_quantity
			ret = true
		end
		if invenItem.depreciations.count > 0
			ret = true
		end
		ret
	end
end
