<!---
EJEMPLO DE USO: 
<cf_dbupdate	table="#Monedas#">
	<cf_dbupdate_join table="TipoCambioEmpresa a" [ type='inner' ] >
	[ on ] a.Mcodigo = #Monedas#.Mcodigo
	  and a.Mes =  <cf_dbupdate_param type="integer" value="#Mes#">
	</cf_dbupdate_join>
	
	<cf_dbupdate_set name='TC' expr="coalesce(TCEtipocambio,-1)" />
	<cf_dbupdate_set name='nombre' type='varchar' value='#nombre#'>

	<cf_dbupdate_where>
	[ where ] a.Ecodigo = <cf_dbupdate_param type="integer" value="#session.Ecodigo#">
	  and a.Periodo = <cf_dbupdate_param type="integer" value="#Periodo#" [ null='no' ] >
	  and a.Mes =     <cf_dbupdate_param type="integer" value="#Mes#" [ null='no' ] > 
	</cf_dbupdate_where>
</cf_dbupdate>

EJEMPLO TRABAJANDO EN =SYBASE=:
<cf_dbupdate table="a" datasource="minisif">
	<cf_dbupdate_join table="b">
		on a.n = b.n
		and a.n != <cf_dbupdate_param type="integer" value="999">
		and a.n != <cf_dbupdate_param type="integer" value="997">
	</cf_dbupdate_join>
	<cf_dbupdate_set name='a.name' expr="b.name" />
	<cf_dbupdate_where>
		WHERE a.n >  <cf_dbupdate_param type="integer" value="3">
		  and a.n >= <cf_dbupdate_param type="integer" value="4">
	</cf_dbupdate_where>
</cf_dbupdate>


--->

<cfparam name="Attributes.table" type="string">
<cfparam name="Attributes.datasource" type="string">
<cfparam name="Attributes.debug" type="boolean" default="no">

<cfif ArrayLen(StructKeyArray(Attributes)) NEQ 3>
	<cfthrow message="Atributos inválidos" detail="Los atributos válidos para cf_dbupdate es: table,datasource,debug">
</cfif>
<cfif Not ThisTag.HasEndTag>
	<cfthrow message="cf_dbupdate requiere de el tag de cierre">
</cfif>

<!--- Validar el datasource --->
<cfif Len(Attributes.datasource) Is 0>
	<cfif IsDefined('session.dsn') and Len(session.dsn) neq 0>
		<cfset Attributes.datasource = session.dsn>
	<cfelse>
		<cfthrow message="Falta el atributo datasource, y session.dsn no est&aacute; definida.">
	</cfif>
</cfif>


<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
<cfinvokeargument name="refresh" value="no">
</cfinvoke>


<cfif not StructKeyExists(Application.dsinfo, Attributes.datasource)>
	<cfthrow message="Datasource no definido: #HTMLEditFormat(Attributes.datasource)#">
</cfif>


<cfif ThisTag.ExecutionMode is 'end'>

<cfparam name="ThisTag.set" default="#ArrayNew(1)#">
<cfparam name="ThisTag.join" default="#ArrayNew(1)#">
<cfparam name="ThisTag.where" default="#ArrayNew(1)#">
<cfparam name="ThisTag.join_params" default="#ArrayNew(1)#">
<cfparam name="ThisTag.where_params" default="#ArrayNew(1)#">

<cfif ArrayLen(ThisTag.set) Is 0>
	<cfthrow message="cf_dbupdate debe incluir al menos un cf_dbupdate_set">
</cfif>


<cfset dstype = Application.dsinfo[Attributes.datasource].type>

<cffunction name="tag_list_to_array" output="false">
	<!--- separa en un array usando como delimitador __CF_DBUPDATE_PARAM__ --->
	<cfargument name="s" type="string">

	<cfset ret = ArrayNew(1)>
	<cfset sep = "__CF_DBUPDATE_PARAM__">
	<cfset smod = " " & s & " ">
	<cfloop from="1" to="#Len(smod)#" index="noseusa">
		<cfset p1 = Find(sep,smod)>
		<cfif p1>
			<cfset sbeg = mid(smod,1,p1-1)>
			<cfset ArrayAppend(ret, sbeg)>
			<cfset smod = mid(smod,p1+Len(sep),Len(smod))>
		</cfif>
	</cfloop>
	<cfset ArrayAppend(ret, smod)>
	<cfreturn ret>
</cffunction>

<cfquery datasource="#Attributes.datasource#">
	<cfif ListFind('sybase,sqlserver', dstype )>
		<!---   SYBASE   --->
		update #Attributes.table# 
		<!--- set --->
		<cfloop from="1" to="#ArrayLen(ThisTag.set)#" index="set_index">
			<cfif set_index is 1> set <cfelse> , </cfif>
			#ThisTag.set[set_index].name# = 
			<cfif StructKeyExists(ThisTag.set[set_index],'expr')>
				<cfset texto_sql = ThisTag.set[set_index].expr>
				#PreserveSingleQuotes(texto_sql)# 
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_#ThisTag.set[set_index].type#"
					value="#ThisTag.set[set_index].value#" null="#ThisTag.set[set_index].null#">
			</cfif>
		</cfloop>
		<!--- /set --->
		<!--- from --->
		<cfset join_param_index = 0>
		from #Attributes.table#
		<cfloop from="1" to="#ArrayLen(ThisTag.join)#" index="join_index">
		#ThisTag.join[join_index].type# join #ThisTag.join[join_index].table#
			<cfset tmp_arr = tag_list_to_array(ThisTag.join[join_index].text)>
			<cfloop from="1" to="#ArrayLen(tmp_arr)#" index="i2">
				<cfif i2 gt 1>
					<cfset join_param_index = join_param_index + 1>
					<cfqueryparam cfsqltype="cf_sql_#ThisTag.join_params[join_param_index].type#"
						value="#ThisTag.join_params[join_param_index].value#" null="#ThisTag.join_params[join_param_index].null#">
				</cfif>
				<cfset tmp_text = tmp_arr[i2]>#PreserveSingleQuotes(tmp_text)#
			</cfloop>
		</cfloop>
		<!--- /from --->
		<!--- where --->
		<cfset where_param_index = 0>
		<cfloop from="1" to="#ArrayLen(ThisTag.where)#" index="where_index">
			<cfset tmp_arr = tag_list_to_array(ThisTag.where[where_index].text)>
			<cfloop from="1" to="#ArrayLen(tmp_arr)#" index="i2">
				<cfif i2 gt 1>
					<cfset where_param_index = where_param_index + 1>
					<cfqueryparam cfsqltype="cf_sql_#ThisTag.where_params[where_param_index].type#"
						value="#ThisTag.where_params[where_param_index].value#" null="#ThisTag.where_params[where_param_index].null#">
				</cfif>
				<cfset tmp_text = tmp_arr[i2]>#PreserveSingleQuotes(tmp_text)#
			</cfloop>
		</cfloop>
		<!--- /where --->
	<cfelseif dstype is 'oracle'>
		<!---   ORACLE   --->
		update ( select
		<cfloop from="1" to="#ArrayLen(ThisTag.set)#" index="set_index">
			<cfif set_index neq 1>, </cfif>
			#ThisTag.set[set_index].name# AS LEFTCOL_#set_index#
			<cfif StructKeyExists(ThisTag.set[set_index],'expr')>
				<cfset texto_sql = ThisTag.set[set_index].expr>
				, #PreserveSingleQuotes(texto_sql)#  AS RIGHTCOL_#set_index#
			</cfif>
		</cfloop>
		<!--- from --->
		<cfset join_param_index = 0>
		from #Attributes.table#
		<cfloop from="1" to="#ArrayLen(ThisTag.join)#" index="join_index">
		#ThisTag.join[join_index].type# join #ThisTag.join[join_index].table# 
			<cfset tmp_arr = tag_list_to_array(ThisTag.join[join_index].text)>
			<cfloop from="1" to="#ArrayLen(tmp_arr)#" index="i2">
				<cfif i2 gt 1>
					<cfset join_param_index = join_param_index + 1>
					<cfqueryparam cfsqltype="cf_sql_#ThisTag.join_params[join_param_index].type#"
						value="#ThisTag.join_params[join_param_index].value#" null="#ThisTag.join_params[join_param_index].null#">
				</cfif>
				<cfset tmp_text = tmp_arr[i2]>#PreserveSingleQuotes(tmp_text)#
			</cfloop>
		</cfloop>
		<!--- /from --->
		<!--- where --->
		<cfset where_param_index = 0>
		<cfloop from="1" to="#ArrayLen(ThisTag.where)#" index="where_index">
			<cfset tmp_arr = tag_list_to_array(ThisTag.where[where_index].text)>
			<cfloop from="1" to="#ArrayLen(tmp_arr)#" index="i2">
				<cfif i2 gt 1>
					<cfset where_param_index = where_param_index + 1>
					<cfqueryparam cfsqltype="cf_sql_#ThisTag.where_params[where_param_index].type#"
						value="#ThisTag.where_params[where_param_index].value#" null="#ThisTag.where_params[where_param_index].null#">
				</cfif>
				<cfset tmp_text = tmp_arr[i2]>#PreserveSingleQuotes(tmp_text)#
			</cfloop>
		</cfloop>
		<!--- /where --->
		)<!--- del subquery del update --->
		<!--- set --->
		<cfloop from="1" to="#ArrayLen(ThisTag.set)#" index="set_index">
			<cfif set_index is 1> set <cfelse> , </cfif>
				LEFTCOL_#set_index# = 
			<cfif StructKeyExists(ThisTag.set[set_index],'expr')>
				RIGHTCOL_#set_index#
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_#ThisTag.set[set_index].type#"
					value="#ThisTag.set[set_index].value#" null="#ThisTag.set[set_index].null#">
			</cfif>
		</cfloop>
		<!--- /set --->
		
	<cfelse>
		<cfthrow message="DBMS no soportada para cf_dbupdate: #Application.dsinfo[Attributes.datasource].type#">
	</cfif>

	<cfif Attributes.debug>
		<cfabort>
	</cfif>
</cfquery>


</cfif>
