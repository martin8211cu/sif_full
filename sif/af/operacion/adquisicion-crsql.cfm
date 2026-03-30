<cfsetting requesttimeout="36000">
<cfset action = "adquisicion-cr.cfm">
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset action = 'adquisicion-cr_JA.cfm'>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>    
    <cfset action = 'adquisicion-cr_Aux.cfm'>
</cfif>
<cfset params = "">
<cffunction name="setParam" access="private">
	<cfargument name="name" required="true">
	<cfargument name="value" required="true">
	<cfset params = ListAppend(params,"#Arguments.name#=#Arguments.value#","&")>
</cffunction>
<cfif isdefined("Form.Alta")>		
	<cfquery datasource="#Session.DSN#">
		insert into DSActivosAdq( 
			Ecodigo        
			, EAcpidtrans    
			, EAcpdoc        
			, EAcplinea      
			, DAlinea        
			, AFMid          
			, AFMMid         
			, CFid           
			, DEid  
			<cfif  isdefined ('form.Alm_Aid') and #form.Alm_Aid# gt 0>  
			, Alm_Aid    
			</cfif>    
			, Mcodigo        
			, DSAtc          
			, SNcodigo       
			, ACcodigo       
			, ACid           
			, DSdescripcion  
			, DSserie        
			, DSplaca        
			, DSfechainidep  
			, DSfechainirev  
			, DSmonto        
			, Status         
			, Usucodigo      
			, AFCcodigo 
		)
		select Ecodigo        
			, EAcpidtrans    
			, EAcpdoc        
			, EAcplinea      
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.DAlinea#">
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.AFMid#" null="#(len(trim(Form.AFMid)) eq 0)#">
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.AFMMid#" null="#(len(trim(Form.AFMMid)) eq 0)#">     
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.CFid#" null="#(len(trim(Form.CFid)) eq 0)#">           
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.DEid#" null="#(len(trim(Form.DEid)) eq 0)#">   
			<cfif  isdefined ('form.Alm_Aid') and #form.Alm_Aid# gt 0>  
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.Alm_Aid#" null="#(len(trim(Form.Alm_Aid)) eq 0)#"> 
			</cfif>
			, Mcodigo        
			, EAtipocambio          
			, SNcodigo       
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.ACcodigo#" null="#(len(trim(Form.ACcodigo)) eq 0)#">       
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.ACid#" null="#(len(trim(Form.ACid)) eq 0)#">           
			, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.DSdescripcion)#">
			, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#Form.DSserie#" null="#(len(trim(Form.DSserie)) eq 0)#">     
			, <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.DSplaca#" null="#(len(trim(Form.DSplaca)) eq 0)#">
			
			, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#dateformat(Form.DSfechainidep,'dd/mm/yyyy')#" null="#(len(trim(Form.DSfechainidep)) eq 0)#">
			, <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#dateformat(Form.DSfechainirev,'dd/mm/yyyy')#" null="#(len(trim(Form.DSfechainirev)) eq 0)#">
			
			, <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#Form.DSmonto#">      
			, 1       
			, <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			, <cf_jdbcquery_param cfsqltype="cf_sql_integer" value="#Form.AFCcodigo#">
		from EAadquisicion
			where Ecodigo = #Session.Ecodigo#
			and EAcpidtrans = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.EAcpidtrans#">
			and EAcpdoc = <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#Form.EAcpdoc#">
			and EAcplinea = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.EAcplinea#">
	</cfquery>
	<cfset setParam("EAcpidtrans",Form.EAcpidtrans)>
	<cfset setParam("EAcpdoc",Form.EAcpdoc)>
	<cfset setParam("EAcplinea",Form.EAcplinea)>
	<cfset setParam("DAlinea",Form.DAlinea)>
<cfelseif isdefined("Form.Baja")>
	<cftransaction>
		<!---Se marca el vale como no usando en un sistema externo con el fin de que puda ser Recuperado En inclusión de Documentos--->
		<cfquery datasource="#session.dsn#">
			update CRDocumentoResponsabilidad
			  set CRDRutilaux = 0 
			 where CRDRid = (select CRDRid 
							   from DSActivosAdq
							  where lin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.lin#">
							  and CRDRid is not null )
		</cfquery>
		<!---Se eliminan todos los Valores variables asociados al proceso de adquisicion--->
		<cfinvoke component="sif.Componentes.DatosVariables" method="BAJAVALOR">
			<cfinvokeargument name="DVTcodigoValor" value="AF">
			<cfinvokeargument name="DVVidTablaVal"  value="#form.lin#">
			<cfinvokeargument name="DVVidTablaSec"  value="2">
		</cfinvoke>
		<!---Elimina la línea de Adquisición--->
		<cfquery datasource="#Session.DSN#">
				delete from DSActivosAdq
				where Ecodigo 	= #Session.Ecodigo#
				and EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.EAcpidtrans#">
				and EAcpdoc		= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.EAcpdoc#">
				and EAcplinea 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.EAcplinea#">
				and DAlinea 	= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.DAlinea#">
				and lin 		= <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.lin#">
		</cfquery>
	</cftransaction>
	<cfset setParam("EAcpidtrans",Form.EAcpidtrans)>
	<cfset setParam("EAcpdoc",Form.EAcpdoc)>
	<cfset setParam("EAcplinea",Form.EAcplinea)>
	<cfset setParam("DAlinea",Form.DAlinea)>
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp
			datasource="#Session.DSN#"
			table="DSActivosAdq"
			redirect="#action#"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#Session.Ecodigo#"
			field2="EAcpidtrans,char,#Form.EAcpidtrans#"
			field3="EAcpdoc,char,#Form.EAcpdoc#"
			field4="EAcplinea,numeric,#Form.EAcplinea#"
			field5="DAlinea,numeric,#Form.DAlinea#"
			field6="lin,numeric,#Form.lin#"
	>
	<cfquery datasource="#Session.DSN#">
			update DSActivosAdq
			set AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AFMid#" null="#(len(trim(Form.AFMid)) eq 0)#">
			, AFMMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AFMMid#" null="#(len(trim(Form.AFMMid)) eq 0)#">
			, CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#" null="#(len(trim(Form.CFid)) eq 0)#">
			, DEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#" null="#(len(trim(Form.DEid)) eq 0)#">   
			, Alm_Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Alm_Aid#" null="#(len(trim(Form.Alm_Aid)) eq 0)#"> 
			, ACcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACcodigo#" null="#(len(trim(Form.ACcodigo)) eq 0)#">
			, ACid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ACid#" null="#(len(trim(Form.AFMid)) eq 0)#">
			, DSdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#HTMLEditFormat(Form.DSdescripcion)#">
			, DSserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DSserie#" null="#(len(trim(Form.DSserie)) eq 0)#">
			, DSplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DSplaca#" null="#(len(trim(Form.DSplaca)) eq 0)#">
			, DSfechainidep = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(Form.DSfechainidep,'dd/mm/yyyy')#" null="#(len(trim(Form.DSfechainidep)) eq 0)#">
			, DSfechainirev = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateformat(Form.DSfechainirev,'dd/mm/yyyy')#" null="#(len(trim(Form.DSfechainirev)) eq 0)#">
			, DSmonto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DSmonto#">
			, Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			, AFCcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.AFCcodigo#">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and EAcpidtrans = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpidtrans#">
			and EAcpdoc = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EAcpdoc#">
			and EAcplinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAcplinea#">
			and DAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DAlinea#">
			and lin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.lin#">
	</cfquery>
	<cfset setParam("EAcpidtrans",Form.EAcpidtrans)>
	<cfset setParam("EAcpdoc",Form.EAcpdoc)>
	<cfset setParam("EAcplinea",Form.EAcplinea)>
	<cfset setParam("DAlinea",Form.DAlinea)>
	<cfset setParam("lin",Form.lin)>
	
	<!---►►Modificación de los Datos Variables◄◄--->
    <cfif isdefined('form.AF_CATEGOR') and isdefined('form.AF_CLASIFI')>
		<cfset Tipificacion = StructNew()>
		<cfset temp = StructInsert(Tipificacion, "AF", "")> 
		<cfset temp = StructInsert(Tipificacion, "AF_CATEGOR", "#form.AF_CATEGOR#")> 
		<cfset temp = StructInsert(Tipificacion, "AF_CLASIFI", "#form.AF_CLASIFI#")> 
		
		<cfinvoke component="sif.Componentes.DatosVariables" method="GETVALOR" returnvariable="CamposForm">
			<cfinvokeargument name="DVTcodigoValor" value="AF">
			<cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
			<cfinvokeargument name="DVVidTablaVal"  value="#form.lin#">
			<cfinvokeargument name="DVVidTablaSec"  value="2">
		</cfinvoke>
		
		<cfparam name="valor" default="0">
		<cfloop query="CamposForm">
			<cfif isdefined('form.#CamposForm.DVTcodigoValor#_#CamposForm.DVid#')>
				<cfset valor = #Evaluate('form.'&CamposForm.DVTcodigoValor&'_'&CamposForm.DVid)#>
			</cfif>
			<cfinvoke component="sif.Componentes.DatosVariables" method="SETVALOR">
				<cfinvokeargument name="DVTcodigoValor" value="AF">
				<cfinvokeargument name="DVid" 		    value="#CamposForm.DVid#">
				<cfinvokeargument name="DVVidTablaVal"  value="#form.lin#">
				<cfinvokeargument name="DVVvalor" 	  	value="#valor#">
				<cfinvokeargument name="DVVidTablaSec" 	value="2"><!---1 (CRDocumentoResponsabilidad) --->
			</cfinvoke>
		</cfloop>
  </cfif>
<cfelseif (isdefined("Form.btnAplicar"))>
	<cfparam name="form.chk" default="">
	<cfif isdefined("Form.EAcpidtrans") and len(trim(Form.EAcpidtrans)) GT 0><cfset form.chk = ListAppend(Form.chk,Form.EAcpidtrans,'|')></cfif>
	<cfif isdefined("Form.EAcpdoc") and len(trim(Form.EAcpdoc)) GT 0><cfset form.chk = ListAppend(Form.chk,Form.EAcpdoc,'|')></cfif>
	<cfif isdefined("Form.EAcplinea") and len(trim(Form.EAcplinea)) GT 0><cfset form.chk = ListAppend(Form.chk,Form.EAcplinea,'|')></cfif>
	<cfif (isdefined("Form.chk")) and ListLen(ListGetAt(Form.chk,1,','),'|') EQ 3>

		<cfloop list="#Form.chk#" index="item">
			<cfquery name="rsImcompleto" datasource="#Session.DSN#">
				select 1 
				from EAadquisicion
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and EAcpidtrans = <cfqueryparam value="#Trim(ListGetAt(item,1,'|'))#" cfsqltype="cf_sql_varchar">
				and EAcpdoc = <cfqueryparam value="#Trim(ListGetAt(item,2,'|'))#" cfsqltype="cf_sql_varchar">
				and EAcplinea = <cfqueryparam value="#Trim(ListGetAt(item,3,'|'))#" cfsqltype="cf_sql_numeric">
				and EAstatus = 0
			</cfquery>
			<cfif rsImcompleto.recordcount gt 0>
				<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('<strong>Error Aplicando Relación: #ListGetAt(item,1,'|')# - #ListGetAt(item,2,'|')#.</strong>')#&errDet=#URLEncodedFormat('La Relación no se encuentra preparada para ser aplicada. Proceso Interrumpido!')#" >
			</cfif>
<!---			<cfinvoke component="sif.Componentes.AF_AltaActivosAdq" method="AF_AltaActivosAdq"
					 returnvariable="rsAltaActivosAdq">
				<cfinvokeargument value="#Trim(ListGetAt(item,1,'|'))#" name="EAcpidtrans" >
				<cfinvokeargument value="#Trim(ListGetAt(item,2,'|'))#" name="EAcpdoc" >
				<cfinvokeargument value="#Trim(ListGetAt(item,3,'|'))#" name="EAcplinea" >
			</cfinvoke>--->
			<cfinvoke component="sif.Componentes.AF_AltaActivosAdq" method="AF_AltaActivosAdq"
				EAcpidtrans="#Trim(ListGetAt(item,1,'|'))#"
				EAcpdoc="#Trim(ListGetAt(item,2,'|'))#" 
				EAcplinea="#Trim(ListGetAt(item,3,'|'))#"
			/>
		</cfloop>
	</cfif>
	<cfset action = "adquisicion-lista.cfm">
    <cfif isdefined("session.LvarJA") and session.LvarJA>
		<cfset action = 'adquisicion-lista_JA.cfm'>
    <cfelseif isdefined("session.LvarJA") and not session.LvarJA>    
        <cfset action = 'adquisicion-lista_Aux.cfm'>
    </cfif>
<cfelseif (isdefined("Form.btnPreparar_Relacion"))>
	<cfparam name="form.chk" default="">
	<cfif isdefined("Form.EAcpidtrans") and len(trim(Form.EAcpidtrans)) GT 0><cfset form.chk = ListAppend(Form.chk,Form.EAcpidtrans,'|')></cfif>
	<cfif isdefined("Form.EAcpdoc") and len(trim(Form.EAcpdoc)) GT 0><cfset form.chk = ListAppend(Form.chk,Form.EAcpdoc,'|')></cfif>
	<cfif isdefined("Form.EAcplinea") and len(trim(Form.EAcplinea)) GT 0><cfset form.chk = ListAppend(Form.chk,Form.EAcplinea,'|')></cfif>
	<cfif (isdefined("Form.chk")) and ListLen(ListGetAt(Form.chk,1,','),'|') EQ 3>
		<cfloop list="#Form.chk#" index="item">
			<cfquery name="rsImcompleto" datasource="#Session.DSN#">
				select 1 
				from DSActivosAdq
				where Ecodigo = #Session.Ecodigo#
				and EAcpidtrans = <cf_jdbcquery_param value="#Trim(ListGetAt(item,1,'|'))#" cfsqltype="cf_sql_varchar">
				and EAcpdoc = <cf_jdbcquery_param value="#Trim(ListGetAt(item,2,'|'))#" cfsqltype="cf_sql_varchar">
				and EAcplinea = <cf_jdbcquery_param value="#Trim(ListGetAt(item,3,'|'))#" cfsqltype="cf_sql_numeric">
				and (AFMid is null or AFMid <= 0
					or AFMMid is null or AFMMid <= 0
					or CFid is null or CFid <= 0
					or DEid is null or DEid <= 0
					or ACcodigo is null or ACcodigo <= 0
					or ACid is null or ACid <= 0
					or DSdescripcion is null or ltrim(rtrim(DSdescripcion)) = ''
					or DSplaca is null or ltrim(rtrim(DSplaca)) = ''
					or DSfechainidep is null 
					or DSfechainirev is null 
					or DSmonto is null or DSmonto <= 0)
			</cfquery>
			<cfquery name="rsDesbalanceado" datasource="#Session.DSN#">
				select a.DAlinea, a.DAmonto, sum(b.DSmonto) as DSmonto
				from DAadquisicion a inner join DSActivosAdq b on
					b.Ecodigo = a.Ecodigo
					and b.EAcpidtrans = a.EAcpidtrans
					and b.EAcpdoc = a.EAcpdoc
					and b.EAcplinea = a.EAcplinea
					and b.DAlinea = a.DAlinea
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.EAcpidtrans = <cfqueryparam value="#Trim(ListGetAt(item,1,'|'))#" cfsqltype="cf_sql_varchar">
				and a.EAcpdoc = <cfqueryparam value="#Trim(ListGetAt(item,2,'|'))#" cfsqltype="cf_sql_varchar">
				and a.EAcplinea = <cfqueryparam value="#Trim(ListGetAt(item,3,'|'))#" cfsqltype="cf_sql_numeric">
				group by a.DAlinea, a.DAmonto
			</cfquery>
			<cfset Lvar_Desbalanceado = false>
			<cfloop query="rsDesbalanceado">
				<cfif rsDesbalanceado.DAmonto neq rsDesbalanceado.DSmonto>
					<cfset Lvar_Desbalanceado = true>
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif rsImcompleto.recordcount gt 0>
				<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('<strong>Error Preparando Relación: #ListGetAt(item,1,'|')# - #ListGetAt(item,2,'|')#.</strong>')#&errDet=#URLEncodedFormat('Datos Incompletos. Proceso Interrumpido!')#" >
			<cfelseif Lvar_Desbalanceado>
				<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('<strong>Error Preparando Relación: #ListGetAt(item,1,'|')# - #ListGetAt(item,2,'|')#.</strong>')#&errDet=#URLEncodedFormat('Relación Desbalanceada. Proceso Interrumpido!')#" >
			<cfelse>
				<cfquery name="x" datasource="#Session.DSN#">
					update EAadquisicion set EAstatus = 1
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and EAcpidtrans = <cfqueryparam value="#Trim(ListGetAt(item,1,'|'))#" cfsqltype="cf_sql_varchar">
					and EAcpdoc = <cfqueryparam value="#Trim(ListGetAt(item,2,'|'))#" cfsqltype="cf_sql_varchar">
					and EAcplinea = <cfqueryparam value="#Trim(ListGetAt(item,3,'|'))#" cfsqltype="cf_sql_numeric">
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<cfset action = "adquisicion-lista.cfm">
    <cfif isdefined("session.LvarJA") and session.LvarJA>
		<cfset action = 'adquisicion-lista_JA.cfm'>
    <cfelseif isdefined("session.LvarJA") and not session.LvarJA>    
        <cfset action = 'adquisicion-lista_Aux.cfm'>
    </cfif>
</cfif>
<cfif ListLen(params) GT 0>
	<cfset params = "?#params#">
</cfif>

<cflocation url="#Action##params#">
