
<cf_templateheader title="Consulta de Modificaciones">
	<cfinclude template="/home/menu/pNavegacion.cfm">

	<cfset tabla 		= "" >
	<cfset bitacoraid 	= "" >
	<cfset descripcion 	= "" >
	<cfset fecha 		= "" >
	<cfset oper 		= "" >
	<cfset ak 			= "" >
	<cfset pk 			= "" >

	<cfif isDefined("form.modo")>

		<cfif isdefined("form.FILTRO_TABLA") and Len(form.FILTRO_TABLA) NEQ 0 >
			<cfset tabla = form.FILTRO_TABLA > 
		<cfelse>
			<cfset tabla = form.TABLA >
		</cfif>

		<cfif isdefined("form.FILTRO_BITACORAID") and Len(form.FILTRO_BITACORAID) NEQ 0 >
			<cfset bitacoraid = form.FILTRO_BITACORAID > 
		<cfelse>
			<cfset bitacoraid = form.BITACORAID >
		</cfif>

		<cfif isdefined("form.FILTRO_DESCRIPCION") and Len(form.FILTRO_DESCRIPCION) NEQ 0 >
			<cfset descripcion = form.FILTRO_DESCRIPCION > 
		<cfelse>
			<cfset descripcion = form.DESCRIPCION >
		</cfif>

		<cfif isdefined("form.FILTRO_FECHA") and Len(form.FILTRO_FECHA) NEQ 0 >
			<cfset fecha = form.FILTRO_FECHA > 
		<cfelse>
			<cfset fecha = form.FECHA >
		</cfif>

		<cfif isdefined("form.FILTRO_OPER") and Len(form.FILTRO_OPER) NEQ 0 >
			<cfset oper = form.FILTRO_OPER > 
		<cfelse>
			<cfset oper = form.OPER >
		</cfif>

		<cfif isdefined("form.FILTRO_AK") and Len(form.FILTRO_AK) NEQ 0 >
			<cfset ak = form.FILTRO_AK > 
		<cfelse>
			<cfset ak = form.AK >
		</cfif>

		<cfif isdefined("form.FILTRO_PK") and Len(form.FILTRO_PK) NEQ 0 >
			<cfset pk = form.FILTRO_PK > 
		<cfelse>
			<cfset pk = form.PK >
		</cfif>
		
	</cfif>

	<cfquery datasource="aspmonitor" name="lista">
		select 
		b.bitacoraid, 
		b.fecha, 
		case b.oper
			when 'I' then 'insert'
			when 'U' then 'update'
			when 'D' then 'delete'
			else b.oper
		end as oper,
		b.tabla, 
		b.pk, 
		b.ak, 
		b.descripcion, 
		b.Usulogin, 
		b.Usucodigo, 
		b.fecha
		from MonBitacora b
		where 1 =1

		<cfif isDefined("form.modo")>
	
			<cfif Len(Trim(bitacoraid)) NEQ 0 >
				and b.bitacoraid <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#bitacoraid#">
			</cfif>
			
			<cfif Len(Trim(fecha)) NEQ 0 AND LSIsDate(fecha)>
				and b.fecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
			</cfif>

			<cfif Len(Trim(oper)) NEQ 0 >
				and b.oper = <cfqueryparam cfsqltype="cf_sql_varchar" value="#oper#">
			</cfif>

			<cfif Len(Trim(tabla)) NEQ 0 >
				and b.tabla like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#tabla#%">
			</cfif>

			<cfif Len(Trim(pk)) NEQ 0 >
				and b.pk <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#pk#">
			</cfif>

			<cfif Len(Trim(ak)) NEQ 0 >
				and b.ak <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#ak#">
			</cfif>

			<cfif Len(Trim(descripcion)) NEQ 0 >
				and b.descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#descripcion#">
			</cfif>

		</cfif>
		order by b.bitacoraid desc
	</cfquery>

	<cfif isDefined("form.modo")>
		<cfif UCase(modo) is 'CAMBIO'>
			<cfinclude template="detalle.cfm">
		<cfelse>
			<cfset mostarPListas() />
		</cfif>
	<cfelse>
		<cfset mostarPListas() />
	</cfif>

<cf_templatefooter>


<cffunction name="mostarPListas" returntype="void" access="private">
	<cfquery name="rsoper" datasource="aspmonitor">
		select '' as value, '--Todos--' as description from dual
    		union all
    	select 'I' as value, 'Insert' as description from dual
			union all
		select 'U' as value, 'Update' as description from dual
			union all
		select 'D' as value, 'Delete' as description from dual
	</cfquery>

	<cfinvoke component = "commons.Componentes.pListas" method="pListaQuery"
	        	query			="#lista#"
	        	desplegar		="bitacoraid,fecha,oper,tabla,pk,ak,descripcion"
	        	etiquetas		="Consecutivo,Fecha,Operación,Tabla,PK,AK,Descripción"
	        	formatos		="S,S,S,S,S,S,S"
	        	align			="left,left,left,left,left,left,left"
	        	ira				="lista.cfm"
	        	form_method		="post"
	        	mostrar_filtro	="yes"
	        	keys			="bitacoraid"
	        	conexion 		="aspmonitor"
	        	rsoper			="#rsoper#"
	 />	

	<table style="width:100%" cellspacing="0" cellpadding="2" align="center" border="0">
		<tr>
			<td align="center">
				<cfoutput><strong>*La lista muestra un máximo de 1000 registros, debe utilizar los filtros.</strong></cfoutput>		
			</td>
		</tr>
	</table>
</cffunction>