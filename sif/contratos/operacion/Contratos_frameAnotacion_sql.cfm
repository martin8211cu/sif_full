<cfset params = "">
<cf_navegacion name="CTContid" navegacion="">
<cf_navegacion name="CTlinea" navegacion="">
<cf_navegacion name="Download" navegacion="">

<cf_dbfunction name="OP_concat"	args="" returnvariable="LvarConcat">

<cfif isdefined("Form.Alta")>

	<cftransaction>
	<cfset AFAfecha2 = '01/01/6100'>
    
    	<cfquery name="rsLineas" datasource="#session.DSN#">
        		select max(CTlinea) as Linea from CTImagenes
                where CTContid = #url.CTContid#
        </cfquery>
        
        <cfif isdefined('rsLineas.Linea') and rsLineas.Linea NEQ "">
        	<cfset Linea = #rsLineas.Linea# + 1>
        <cfelse>
        	<cfset Linea = 1>
         
        </cfif>
        
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into CTAnotaciones 
			(Ecodigo, CTContid, CTAfecha, CTAanotacion,CTlinea) values (
			#session.Ecodigo#, 
			<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#url.CTContid#">,  
			<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#Now()#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Anotacion#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Linea#">
            )
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsInsert">
		<cfif len(trim(form.CTimagen))>
		  <cfset form.CTnombreImagen= UCASE(form.CTnombreImagen)>
		 		<cfquery name="rsInsert2" datasource="#session.DSN#">
				insert into CTImagenes 
				(Ecodigo, CTContid, CTlinea, CTimagen, CTextension,CTnombre)values (
				#session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTContid#">, 
				#Linea#, 
				<cf_dbupload filefield="CTimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CTnombreImagen#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CTnombre#">)
			</cfquery>
		</cfif>

	</cftransaction>
<cfelseif isdefined("Form.Baja")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete from CTImagenes 
				where Ecodigo = #session.Ecodigo#
				and CTContid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTContid#">
				and CTlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTlinea#">
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from CTAnotaciones 
				where Ecodigo = #session.Ecodigo#
				and CTContid 	  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTContid#">
				and CTlinea  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTlinea#">	
		</cfquery>
	</cftransaction>
<cfelseif isdefined("Form.Cambio")>
	<cftransaction>
			<cfquery datasource="#session.dsn#">
				update CTAnotaciones 
					set CTAfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#LSParseDateTime(form.AFAfecha1)#">, 
					CTAanotacion 	  = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#form.Anotacion#">
				where Ecodigo     = #session.Ecodigo#
				and CTContid 		  = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CTContid#">
				and CTlinea      = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.CTlinea#">
			</cfquery>	
	   <cfif len(trim(form.CTimagen))>
	   <cfset form.CTnombreImagen= UCASE(form.CTnombreImagen)>
			<cfquery datasource="#session.dsn#">
					update CTImagenes 
						set CTimagen = <cf_dbupload filefield="CTimagen" accept="image/*,text/*,application/*" datasource="#session.dsn#">,
						CTextension =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CTnombreImagen#">,
                        CTnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CTnombre#">
					where Ecodigo 	 = #session.Ecodigo#
					and CTContid          = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTContid#">
					and CTlinea     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTlinea#">
			</cfquery>
		</cfif>		
	</cftransaction>
<cfelseif IsDefined("form.Download")>	
	<cfquery name="rsArchivo" datasource="#session.dsn#">
		select cast(a.CTnombre as varchar) #LvarConcat# '.' #LvarConcat# a.CTextension as archivo,
		      CTimagen
		  from CTImagenes a inner join CTAnotaciones b
		    on a.CTContid = b.CTContid
		where a.CTContid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CTContid#" null="#Len(url.CTContid) Is 0#">
		and a.CTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTlinea#" null="#Len(form.CTlinea) Is 0#">
		and a.Ecodigo =#session.Ecodigo#
	</cfquery>

	<cfset LvarFile = GetTempFile(GetTempDirectory(),"archivos")>
	<cffile action="write" file="#LvarFile#" output="#rsArchivo.CTimagen#" >

	<cfheader name="Content-Disposition"	value="attachment;filename=#rsArchivo.archivo#">
	<cfheader name="Expires" value="0">
	<cfcontent type="*/*" reset="yes" file="#LvarFile#" deletefile="yes">

	<cflocation url="Contratos_frameAnotacion.cfm?CTContid=#url.CTContid#">
</cfif>
<cflocation url="Contratos_frameAnotacion.cfm?CTContid=#url.CTContid#&Ecodigo=#session.Ecodigo#">
