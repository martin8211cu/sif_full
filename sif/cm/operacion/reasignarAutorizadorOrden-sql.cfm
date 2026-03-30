<cfif isdefined("Form.Procesar")>	
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cftransaction>
		<!--- Toma el monto del comprador autorizado para después compararlo con el monto de la ordende compra --->
		<cfquery name="rsmontoC" datasource="#Session.DSN#">
			select a.Mcodigo, a.CMCmontomax as monto, round(coalesce(tc.TCventa,1.00) * a.CMCmontomax,2) as montoloc
			from CMCompradores a
				inner join Htipocambio tc
					on tc.Mcodigo = a.Mcodigo
					and tc.Ecodigo = a.Ecodigo
					and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
		</cfquery>
		<cfset mens= "">
		<cfset listaValores = form.rb>
		<cfloop index = "Orden" list = "#listaValores#"  delimiters="," >
		   <!--- Toma el monto de la orden de compra para compararlo con el monto del comprador autorizado --->
			<cfquery name="rsMontoO" datasource="#Session.DSN#">
				select Mcodigo, EOtotal as monto, round(EOtotal * coalesce(EOtc,1.00),2) as montoloc, <cf_dbfunction name="to_char" args="EOnumero">#_Cat#'-'#_Cat#Observaciones as des
				from  EOrdenCM
				where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#orden#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<cfset descripcionOrden = rsMontoO.des>
			<!--- compara el monto del comprador autorizado con el monto de la orden de compra
			si es mayor o igual, se le es permitido ser autorizador de esa orden, si no, no lo es --->
			<cfset montook = false>
			<cfif rsMontoC.Mcodigo eq rsMontoO.Mcodigo>
				<cfif rsMontoC.monto gte rsMontoO.monto>
					<cfset montook = true>
				</cfif>
			<cfelse>
				<cfif rsMontoC.montoloc gte rsMontoO.montoloc>
					<cfset montook = true>
				</cfif>
			</cfif>
			<cfif montook>
				<!--- Reasigna el comprador autorizado --->
				<cfquery name="insBitacora" datasource="#Session.DSN#">
					update  CMAutorizaOrdenes 
					set CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
					where 
						EOidorden= <cfqueryparam cfsqltype="cf_sql_numeric" value="#orden#">
						and CMAestado=0
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
			<cfelse>
				<!--- concatena el mensaje con la descripcion de las ordenes que no se actualizaron con el nuevo 
				Autorizador por que este no posee permiso para ser autorizador de los montos que continen esas 
				ordenes --->
				<cfif mens eq "">
					<cfset mens="'"&descripcionOrden&"'">
				<cfelse>
					<cfset mens= mens & ",  '"&descripcionOrden&"'">
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
	<cfif mens neq "">
		<!--- imprime el mensaje de error --->
		<cfset Request.Error.Url = "reasignarAutorizadorOrden.cfm?comprador=#form.comprador#">
		<cf_errorCode	code = "50323"
						msg  = "Al Autorizador no le pueden asignar la(s) siguiente(s) ordene(s) debido a que no posee permiso para Autorizarlas: @errorDat_1@"
						errorDat_1="#mens#"
		>
	</cfif>
</cfif>

