
<cfif isdefined ('form.Lista')>
	<cflocation url="Productos.cfm">
</cfif>

<cfif isdefined ('form.ALTA')>
	<cfquery name="rsValida" datasource="#session.dsn#">
		select rtrim(MIGProcodigo) as MIGProcodigo
		from MIGProductos
		where MIGProcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.MIGProcodigo)#">
		and Ecodigo=#session.Ecodigo#
	</cfquery>
	<cfif rsValida.recordCount eq 0>	
		<cftransaction>
			<cfinvoke component="mig.Componentes.Productos" method="Alta" returnvariable="MIGProid">
				<cfinvokeargument name="MIGProcodigo" 				value="#form.MIGProcodigo#"/>
				<cfinvokeargument name="MIGPronombre" 				value="#form.MIGPronombre#"/>
				<cfinvokeargument name="Dactiva" 					value="#form.Dactiva#"/>
			<cfif form.SgID gt 0>	
				<cfinvokeargument name="MIGProSegid" 				value="#form.SgID#"/>
			<cfelse>
				<cfinvokeargument name="MIGProSegid" 				value="null"/>
			</cfif>
			<cfif form.SgID2 gt 0>	
				<cfinvokeargument name="MIGProSegid2" 				value="#form.SgID2#"/>
			<cfelse>
				<cfinvokeargument name="MIGProSegid2" 				value="null"/>
			</cfif>
			<cfif form.SgID3 gt 0>	
				<cfinvokeargument name="MIGProSegid3" 				value="#form.SgID3#"/>
			<cfelse>
				<cfinvokeargument name="MIGProSegid3" 				value="null"/>
			</cfif>
			<cfif form.Ucodigo NEQ "">	
				<cfinvokeargument name="id_unidad_medida" 			value="#form.Ucodigo#"/>
			<cfelse>
				<cfinvokeargument name="id_unidad_medida" 				value="null"/>
			</cfif>
				<cfinvokeargument name="MIGProLinid" 				value="#form.LID#"/>
			<cfif form.LID2 gt 0>	
				<cfinvokeargument name="MIGProLinid2" 				value="#form.LID2#"/>
			<cfelse>
				<cfinvokeargument name="MIGProLinid2" 				value="null"/>
			</cfif>
			<cfif form.LID3 gt 0>	
				<cfinvokeargument name="MIGProLinid3" 				value="#form.LID3#"/>
			<cfelse>
				<cfinvokeargument name="MIGProLinid3" 				value="null"/>
			</cfif>
			<cfif form.LID4 gt 0>	
				<cfinvokeargument name="MIGProLinid4" 				value="#form.LID4#"/>
			<cfelse>
				<cfinvokeargument name="MIGProLinid4" 				value="null"/>
			</cfif>
			<cfif form.MIGProlinea5 NEQ "">
				<cfinvokeargument name="MIGProlinea5"				value="#form.MIGProlinea5#"/>
			<cfelse>
				<cfinvokeargument name="MIGProlinea5"				value=""/>
			</cfif>
			<cfif form.MIGProplanta NEQ "" >			
				<cfinvokeargument name="MIGProplanta"				value="#form.MIGProplanta#"/>
			<cfelse>
				<cfinvokeargument name="MIGProplanta"				value=""/>
			</cfif>
			<cfif isdefined ('form.MIGProesproducto')>
				<cfinvokeargument name="MIGProesproducto"			value="#form.MIGProesproducto#"/>
			<cfelse>
				<cfinvokeargument name="MIGProesproducto"			value="P"/>
			</cfif>
			<cfif isdefined ('form.MIGProesproducto')>
				<cfinvokeargument name="MIGProesnuevo"				value="#form.MIGProesnuevo#"/>
			<cfelse>
				<cfinvokeargument name="MIGProesnuevo"			value="1"/>
			</cfif>
				
			</cfinvoke>	
		</cftransaction>
		<cfset modo='CAMBIO'>
		<cflocation url="Productos.cfm?MIGProid=#MIGProid#&modo=#modo#">
	<cfelse>
		<cfthrow type="toUser" message="El Código #rsValida.MIGProcodigo# ya existe en Sistema.">
	</cfif>
</cfif>
<cfif isdefined ('form.CAMBIO')>
	<cftransaction>
		<cfinvoke component="mig.Componentes.Productos" method="Cambio" >
			<cfinvokeargument name="MIGProid" 					value="#form.MIGProid#"/>
		<cfif isdefined ('form.Dactiva') and form.Dactiva NEQ "">
			<cfinvokeargument name="Dactiva" 					value="#form.Dactiva#"/>
		</cfif>
			<cfinvokeargument name="MIGPronombre" 				value="#form.MIGPronombre#"/>
		<cfif form.SgID gt 0>	
			<cfinvokeargument name="MIGProSegid" 				value="#form.SgID#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid" 				value="null"/>
		</cfif>
		<cfif form.SgID2 gt 0>	
			<cfinvokeargument name="MIGProSegid2" 				value="#form.SgID2#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid2" 				value="null"/>
		</cfif>
		<cfif form.SgID3 gt 0>	
			<cfinvokeargument name="MIGProSegid3" 				value="#form.SgID3#"/>
		<cfelse>
			<cfinvokeargument name="MIGProSegid3" 				value="null"/>
		</cfif>
		<cfif form.Ucodigo NEQ "">	
			<cfinvokeargument name="id_unidad_medida" 			value="#form.Ucodigo#"/>
		<cfelse>
			<cfinvokeargument name="id_unidad_medida" 				value="null"/>
		</cfif>
			<cfinvokeargument name="MIGProLinid" 				value="#form.LID#"/>
		<cfif form.LID2 gt 0>	
			<cfinvokeargument name="MIGProLinid2" 				value="#form.LID2#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid2" 				value="null"/>
		</cfif>
		<cfif form.LID3 gt 0>	
			<cfinvokeargument name="MIGProLinid3" 				value="#form.LID3#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid3" 				value="null"/>
		</cfif>
		<cfif form.LID4 gt 0>	
			<cfinvokeargument name="MIGProLinid4" 				value="#form.LID4#"/>
		<cfelse>
			<cfinvokeargument name="MIGProLinid4" 				value="null"/>
		</cfif>
		<cfif form.MIGProlinea5 NEQ "">
			<cfinvokeargument name="MIGProlinea5"				value="#form.MIGProlinea5#"/>
		<cfelse>
			<cfinvokeargument name="MIGProlinea5"				value=""/>
		</cfif>
		<cfif form.MIGProplanta NEQ "" >			
			<cfinvokeargument name="MIGProplanta"				value="#form.MIGProplanta#"/>
		<cfelse>
			<cfinvokeargument name="MIGProplanta"				value=""/>
		</cfif>
			<cfinvokeargument name="MIGProesproducto"			value="#form.MIGProesproducto#"/>
			<cfinvokeargument name="MIGProesnuevo"				value="#form.MIGProesnuevo#"/>
		</cfinvoke>	
	</cftransaction>
<cfset modo='CAMBIO'>
<cflocation url="Productos.cfm?MIGProid=#form.MIGProid#&modo=#modo#">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cfquery name="Valida" datasource="#Session.DSN#">
		select a.MIGMid, b.MIGMcodigo
		from MIGFiltrosmetricas a
			left join MIGMetricas b
				on a.MIGMid=b.MIGMid
				and a.Ecodigo=b.Ecodigo
		where a.MIGMdetalleid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MIGProid#" >
		and a.MIGMtipodetalle='P'
		and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
	</cfquery>
	<cfquery name="Valida2" datasource="#Session.DSN#">
		select MIGMid
		from F_Datos
		where MIGProid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MIGProid#" >
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
	</cfquery>
	<cfif Valida.recordCount GT 0 or Valida2.recordCount GT 0>
		<cfthrow type="toUser" message="El producto no puede ser inactivado ya que tiene asociaciones.">
	<cfelse>
		<cftransaction>
		<cfinvoke component="mig.Componentes.Productos" method="Baja" >
			<cfinvokeargument name="MIGProid" 		value="#form.MIGProid#"/>
		</cfinvoke>	
	</cftransaction>
	</cfif>
<cflocation url="Productos.cfm">
</cfif>
<cfif isdefined ('form.Nuevo')>
	<cflocation url="Productos.cfm?Nuevo=Nuevo">
</cfif>

