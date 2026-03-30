<!---  <cfdump var="#form#">
<cfdump var="#url#">  --->
<cfif isdefined('session.FMT01COD') and len(trim(session.FMT01COD))>
	<cfset url.FMT01COD = session.FMT01COD>
</cfif>
<cfif isdefined('url.FMT01COD') and len(trim(url.FMT01COD))>
	<cfset form.FMT01COD = url.FMT01COD>
</cfif>

<cfif isdefined("Form.btnEliminar")>
	<!--- Borrar linea --->
	
	<cfquery name="delete_FMT002" datasource="#session.DSN#">			
		delete from FMT002 
		where FMT02LIN = <cfqueryparam value="#form.FMT02LIN#" cfsqltype="cf_sql_integer" >
		  and FMT01COD = <cfqueryparam value="#form.FMT01COD#" cfsqltype="cf_sql_varchar"  >	
	</cfquery>
	<cflocation url="editor.cfm?FMT01COD=#URLEncodedFormat(form.FMT01COD)#" addtoken="no">
	  
<!--- Caso 3: Modificar linea --->
<cfelseif isdefined("url.btnInsertCampo")>
	<cfquery name="rsFMT002" datasource="#session.DSN#">
		select FMT02LIN
		 from FMT002
		where FMT01COD = <cfqueryparam value="#session.FMT01COD#" cfsqltype="cf_sql_varchar"  >	
		  and FMT11NOM = <cfqueryparam value="#url.FMT11NOM#" cfsqltype="cf_sql_varchar"  >	
	</cfquery>
	<cfif rsFMT002.recordCount EQ 0>
		<cfquery name="rsFMT002" datasource="#session.DSN#">
			select coalesce(max(FMT02LIN),0)+1 as maximo
			 from FMT002
			where FMT01COD = <cfqueryparam value="#session.FMT01COD#" cfsqltype="cf_sql_varchar"  >	
		</cfquery>
		<cfquery name="update_FMT002" datasource="#session.DSN#">
			insert into FMT002 
			(	FMT01COD, FMT02LIN, FMT11NOM, FMT02TIP, FMT02FMT, 
				
				FMT02CAM, FMT02DES, FMT02LON, FMT02DEC, 
				FMT02TPL, FMT02TAM, FMT02FIL, FMT02COL, FMT02AJU, 
				FMT02POS, FMT02JUS, FMT02PRE, FMT02SUF, FMT02STS, 
				FMT02SPC, FMT02SQL, FMT02BOL, FMT02UND, FMT02ITA, 
				FMT02TOT, FMT02PAG, FMT02CLR, FMT07NIV, BMUsucodigo)
			values (
				<cfqueryparam value="#session.FMT01COD#" cfsqltype="cf_sql_varchar">, 
				#rsFMT002.maximo#,
				<cfqueryparam value="#url.FMT11NOM#" cfsqltype="cf_sql_varchar">, 
				2,
				'-1',
				
				' ', ' ', 0, 0, 
				' ', 0, 0, 0, 0, 
				'1', 1, ' ', ' ', 0, 
				0, 0, 0, 0, 0, 
				0, 0, ' ', 0, 
				#session.Usucodigo#
			)
		</cfquery>
		<cfoutput>
		<script language="javascript">
			parent.document.getElementById('iframe_detalle').src='FMT002-list.cfm?FMT01COD=#URLEncodedFormat(session.FMT01COD)#';
		</script>
		</cfoutput>

	</cfif>
<cfelseif isdefined("form.btnCambiaFmts")>
	<cfloop index="LvarLin" list="#form.FMT02LIN#">
		<cfset LvarFmt = evaluate("form.FMT02FMT_#LvarLin#")>
		<cfset LvarPre = evaluate("form.FMT02PRE_#LvarLin#")>
		<cfset LvarSuf = evaluate("form.FMT02SUF_#LvarLin#")>
		<cfquery name="update_FMT002" datasource="#session.DSN#">
			update FMT002
			   set FMT02FMT = <cfqueryparam value="#LvarFmt#"   cfsqltype="cf_sql_varchar" >
			     , FMT02PRE = <cfqueryparam value="#LvarPre#"   cfsqltype="cf_sql_varchar" >
			     , FMT02SUF = <cfqueryparam value="#LvarSuf#"   cfsqltype="cf_sql_varchar" >
		     where FMT01COD = <cfqueryparam value="#form.FMT01COD#" cfsqltype="cf_sql_char"    >
			   and FMT02LIN = <cfqueryparam value="#LvarLin#" cfsqltype="cf_sql_integer" >
		</cfquery>
	</cfloop>
	<cflocation url="editor.cfm?FMT01COD=#URLEncodedFormat(form.FMT01COD)#" addtoken="no">
<cfelseif isdefined("form.btnModificar")>
	<cfif form.FMT02TIP EQ "2">
		<cfquery name="rsFMT011" datasource="#session.DSN#">
			select FMT011.FMT11NOM 
			  from FMT001, FMT011
			 where FMT001.FMT01COD = <cfqueryparam value="#form.FMT01COD#" cfsqltype="cf_sql_char">
			   and FMT011.FMT00COD = FMT001.FMT01TIP
			   and FMT011.FMT02SQL = <cfqueryparam value="#form.FMT02CAM#"   cfsqltype="cf_sql_integer" >
		</cfquery>
	</cfif>
		
	<cfquery name="update_FMT002" datasource="#session.DSN#">
		update FMT002
		   set FMT02CAM = 
		   			<cfif form.FMT02TIP EQ 1>
						'ETIQUETA'
					<cfelse>
						<cfqueryparam value="#form.FMT02CAM#" cfsqltype="cf_sql_varchar" >
					</cfif>
			  ,FMT02DES = <cf_jdbcquery_param value="#form.FMT02DES#" cfsqltype="cf_sql_varchar" >
			  ,FMT02FIL = <cf_jdbcquery_param value="#form.FMT02FIL#"   cfsqltype="cf_sql_float" >
			  ,FMT02COL = <cf_jdbcquery_param value="#form.FMT02COL#"   cfsqltype="cf_sql_float" >
			  ,FMT02LON = <cf_jdbcquery_param value="#form.FMT02LON#"   cfsqltype="cf_sql_float" >
			  ,FMT02DEC = <cf_jdbcquery_param value="#form.FMT02DEC#"   cfsqltype="cf_sql_integer" >
			  ,FMT02FMT = <cf_jdbcquery_param value="#form.FMT02FMT#"   cfsqltype="cf_sql_varchar" >
			  ,FMT02PRE = <cf_jdbcquery_param value="#form.FMT02PRE#"   cfsqltype="cf_sql_varchar" >
			  ,FMT02SUF = <cf_jdbcquery_param value="#form.FMT02SUF#"   cfsqltype="cf_sql_varchar" >
			  ,FMT02TPL = <cf_jdbcquery_param value="#form.FMT02TPL#"   cfsqltype="cf_sql_varchar" >
			  ,FMT02TAM = <cf_jdbcquery_param value="#form.FMT02TAM#"   cfsqltype="cf_sql_tinyint" >
			  ,FMT02AJU = <cfif isdefined("form.FMT02AJU")>1<cfelse>0</cfif>
			  ,FMT02POS = <cf_jdbcquery_param value="#form.FMT02POS#"   cfsqltype="cf_sql_char" >
			  ,FMT02JUS = <cf_jdbcquery_param value="#form.FMT02JUS#"   cfsqltype="cf_sql_tinyint" >
			  ,FMT02TIP = <cf_jdbcquery_param value="#form.FMT02TIP#"   cfsqltype="cf_sql_tinyint" >
			  ,FMT02SPC = <cf_jdbcquery_param value="#form.FMT02SPC#"   cfsqltype="cf_sql_bit" >
			  ,FMT02SQL = <cf_jdbcquery_param value="#form.FMT02CAM#"   cfsqltype="cf_sql_integer" >
			  ,FMT02CLR = upper( <cf_jdbcquery_param value="#form.FMT02CLR#"   cfsqltype="cf_sql_char" > )
			  ,FMT07NIV = <cf_jdbcquery_param value="#form.FMT07NIV#"   cfsqltype="cf_sql_integer" >
			 <cfif isdefined("form.FMT02STS")>, FMT02STS = 1<cfelse>, FMT02STS = 0</cfif>
			 <cfif isdefined("form.FMT02BOL")>, FMT02BOL = 1<cfelse>, FMT02BOL = 0</cfif>
			 <cfif isdefined("form.FMT02UND")>, FMT02UND = 1<cfelse>, FMT02UND = 0</cfif>
			 <cfif isdefined("form.FMT02ITA")>, FMT02ITA = 1<cfelse>, FMT02ITA = 0</cfif>
			 <cfif isdefined("form.FMT02TOT")>, FMT02TOT = 1<cfelse>, FMT02TOT = 0</cfif>
			 <cfif isdefined("form.FMT02PAG")>, FMT02PAG = 1<cfelse>, FMT02PAG = 0</cfif>
			 <cfif form.FMT02TIP EQ "1">
			    , FMT11NOM = NULL
			 <cfelse>
			 	, FMT11NOM = <cf_jdbcquery_param value="#rsFMT011.FMT11NOM#"   cfsqltype="cf_sql_varchar">
			 </cfif>

		   where FMT01COD = <cf_jdbcquery_param value="#form.FMT01COD#" cfsqltype="cf_sql_char"    >
			 and FMT02LIN = <cf_jdbcquery_param value="#form.FMT02LIN#" cfsqltype="cf_sql_integer" >
			 <!---
			 and ts_rversion = convert(varbinary,#lcase(form.ts_rversion)#)
			 --->
	</cfquery>
	<cflocation url="editor.cfm?FMT01COD=#URLEncodedFormat(form.FMT01COD)#&FMT02LIN=#URLEncodedFormat(form.FMT02LIN)#" addtoken="no">
	<cflocation url="FMT002-form.cfm?linea=#URLEncodedFormat(form.FMT02LIN)#" addtoken="no">

</cfif>

	<cflocation url="../EFormatosImpresion.cfm?FMT01COD=#form.FMT01COD#">
