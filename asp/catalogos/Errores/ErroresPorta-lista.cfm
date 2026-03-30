<cfquery name="rsLista" datasource="sifcontrol">
		 select  CERRcod, CERRmsg
			from CodigoError
		 where 1=1
		 <cfif isdefined ('form.filtro_CERRcod') and len(trim(form.filtro_CERRcod)) gt 0>
			and CERRcod= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.filtro_CERRcod#">
		 </cfif>
		  <cfif isdefined ('form.filtro_CERRmsg') and len(trim(form.filtro_CERRmsg)) gt 0>
			and lower(CERRmsg) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#LCASE(form.filtro_CERRmsg)#%">
		 </cfif>
		 order by CERRcod
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
	<cfinvokeargument name="query" 			  value="#rsLista#"/>
	<cfinvokeargument name="desplegar"  	  value="CERRcod,CERRmsg"/>
	<cfinvokeargument name="etiquetas"  	  value="C&oacute;digo,Error"/>
	<cfinvokeargument name="formatos"   	  value="Z,S"/>
	<cfinvokeargument name="align" 			  value="left,left"/>
	<cfinvokeargument name="ajustar"   		  value="N"/>
	<cfinvokeargument name="irA"              value="#irA#"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="keys"             value="CERRcod"/>
	<cfinvokeargument name="mostrar_filtro"   value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="Conexion" 		  value="sifcontrol"/>
</cfinvoke>			