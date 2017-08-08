class WklogmaterialController < ApplicationController
  unloadable



  def index
  end 
  
  def modifyProductDD
		pctArr = ""	
		if params[:ptype] == "product"
			pctObj = WkProduct.where(:category_id => params[:id]).order(:name)
		elsif params[:ptype] == "product_brand"
			pObj = WkProduct.find(params[:id].to_i)
			pctObj = pObj.brands.order(:name)
		elsif params[:ptype] == "product_item"
			sqlQuery = "select it.id, pi.product_id, pi.brand_id, pi.product_attribute_id, pi.product_model_id, pi.part_number, it.cost_price, it.selling_price, it.currency, it.available_quantity, it.uom_id from wk_product_items pi left outer join wk_inventory_items it on pi.id = it.id where pi.product_id = #{params[:id]}"
			pctObj = WkProductItem.find_by_sql(sqlQuery)
			#pctObj = WkProductItem.where(:product_id => params[:product_id], :brand_id => params[:id])
		else
			#pctObj = WkProductItem.find(params[:id].to_i) unless params[:id].blank?
			pctObj = WkInventoryItem.find(params[:id].to_i) unless params[:id].blank?
		end
		
		if params[:ptype] == "product_item"
			pctObj.each do | entry|
				pctArr << entry.id.to_s() + ',' +  (entry.part_number.to_s() +' - '+ entry.product_attribute.name.to_s()  +' - '+  (entry.currency.to_s() + ' ' +  entry.selling_price.to_s()) ) + "\n" 
			end
		elsif params[:ptype] == "inventory_item"
			pctArr << pctObj.id.to_s() + ',' + pctObj.available_quantity.to_s() +','+ pctObj.cost_price.to_s()  +','+  pctObj.currency.to_s() + ',' +  pctObj.selling_price.to_s() unless pctObj.blank?
		elsif params[:ptype] == "product_attribute"
			pctArr << pctObj.id.to_s() + ',' + pctObj.available_quantity.to_s() +','+ pctObj.cost_price.to_s()  +','+  pctObj.currency.to_s() + ',' +  pctObj.selling_price.to_s() unless pctObj.blank?  			
		else		
			pctObj.each do | entry|
				pctArr << entry.id.to_s() + ',' +  entry.name.to_s()  + "\n" 
			end
		end
		
		respond_to do |format|
			format.text  { render :text => pctArr }
		end
	end  
end
