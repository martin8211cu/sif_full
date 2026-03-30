<!--- 
	Modificado por: Ana Villavicencio+
	Fecha: 10 de marzo del 2006
	Motivo: Se agrego la funcionalidad de volver a la pantalla de regitro de notas de credito para el caso de que el documento
			vengo desde notas de credito (Aplicar y Relacionar la Nota de Credito).
			Validacion de indicador AplicaRel.
			
	Modificado por Gustavo Fonseca H.
		Fehca: 31-10-2005.
		Motivo: se cambia DRdocumento2 por DRdocumento para que pueda hacer el Update.
--->

<cfset cambioEncab = false>	
<cfif not (isDefined("Form.EFfecha") and Trim(Form.EFfecha) EQ Trim(Form._EFfecha))>
	<cfset cambioEncab = true>
</cfif>

<cfif isdefined("Form.AgregarE")>
	<cfquery datasource="#Session.DSN#">
		insert into EFavor (Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, EFtipocambio, EFtotal, EFselect, Ccuenta,  
						EFfecha, EFusuario) 
		values 
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.McodigoE#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#Form.EFtipocambio#">, 
			0,
			0,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaE#">,
			<cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.EFfecha)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">
			)
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">
<cfelseif isdefined("Form.CambiarE")>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">				
<cfelseif isdefined("Form.BorrarE")>
	<cfquery datasource="#Session.DSN#">
		delete from DFavor 
		where Ecodigo    = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
		  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
	</cfquery>			  			  
	<cfquery datasource="#Session.DSN#">
		delete from EFavor 
		where Ecodigo    = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
		  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
	</cfquery>			  			  
	<cfset modo="ALTA">
	<cfset modoDet="ALTA">
<cfelseif isdefined("Form.AgregarD")>
	<!--- Calcular el tipo de cambio --->
	<cfif Form.FC EQ "calculado">
		<cfset tipocambio = #Val(Form.DFmontodoc)# / #Val(Form.DFmonto)#>
	<cfelseif Form.FC EQ "iguales">
		<cfset tipocambio = 1.0>
	<cfelseif Form.FC EQ "encabezado">
		<cfset tipocambio = #Val(Form.EFtipocambio)#>
	</cfif>
	
	<cfif cambioEncab> 
		<cf_dbtimestamp
		datasource="#session.dsn#"
		table="EFavor" 
		redirect="listaDocsAfavorCC.cfm"
		timestamp="#Form.timestampE#"
		field1="Ecodigo,integer,#Session.Ecodigo#"
		field2="CCTcodigo,char,#Form.CCTcodigo#"
		field3="Ddocumento,char,#Form.Ddocumento#">
					
		<cfquery datasource="#Session.DSN#">
			update EFavor set SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			, EFfecha=  <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(Form.EFfecha,'YYYYMMDD')#">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
		</cfquery>
	</cfif>
	<cfquery datasource="#Session.DSN#">
		insert into DFavor (
			Ecodigo,
			CCTcodigo,
			Ddocumento,          
			CCTRcodigo,
			DRdocumento,
			SNcodigo,
			DFmonto,
			Ccuenta,          
			Mcodigo,
			DFtotal,
			DFmontodoc,
			DFtipocambio )
		values 
		(
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTRcodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRdocumento#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DFmonto#">,<!--- Porque se guarda en dos campos diferentes ---> 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaD#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.McodigoD#">,
			<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DFmonto#">,<!--- Porque se guarda en dos campos diferentes ---> 
			<cfqueryparam cfsqltype="cf_sql_money" value="#Form.DFmontodoc#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#tipocambio#">
		)
    </cfquery>    
    
	<cfquery datasource="#Session.DSN#">
		update EFavor set
		  EFtotal=
			(select coalesce(sum(DFtotal),0.0) from DFavor
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
				 and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
			)          
		  where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
	</cfquery>

	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">				
<cfelseif isdefined("Form.BorrarD")>
	<cfquery datasource="#Session.DSN#">
		delete from DFavor
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
			  and CCTRcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTRcodigo#">
			  and DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRdocumento#">
	</cfquery>

	<cfquery datasource="#Session.DSN#">
		update EFavor set
		EFtotal=
			(select coalesce(sum(DFtotal),0.0) from DFavor
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
				 and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
			)          
		  where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">								  
<cfelseif isdefined("Form.BorrarDD")>
	<cfquery datasource="#Session.DSN#">
		delete from DFavor
		  where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
	</cfquery>
    
	<cfquery datasource="#Session.DSN#">
		update EFavor set
		EFtotal=
			(select coalesce(sum(DFtotal),0.0) from DFavor
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
				 and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
			)          
		  where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset modoDet="ALTA">								  
<cfelseif isdefined("Form.CambiarD")>		
	<!--- Calcular el tipo de cambio --->
	<cfif Form.FC EQ "calculado">
		<cfset tipocambio = #Val(Form.DFmontodoc)# / #Val(Form.DFmonto)#>
	<cfelseif Form.FC EQ "iguales">
		<cfset tipocambio = 1.0>
	<cfelseif Form.FC EQ "encabezado">
		<cfset tipocambio = #Val(Form.EFtipocambio)#>
	</cfif>
	
	<cfif cambioEncab> 
			<cf_dbtimestamp
			datasource="#session.dsn#"
			table="EFavor" 
			redirect="listaDocsAfavorCC.cfm"
			timestamp="#Form.timestampE#"
			field1="Ecodigo,integer,#Session.Ecodigo#"
			field2="CCTcodigo,char,#Form.CCTcodigo#"
			field3="Ddocumento,char,#Form.Ddocumento#">
		
		<cfquery datasource="#Session.DSN#">
			update EFavor set SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
			, EFfecha=  <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(Form.EFfecha)#">
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
		</cfquery>
	</cfif>

	<cfquery name="rsSaldo" datasource="#Session.DSN#">
		<!--- TOMA EL SALDO DEL DOCUMENTO  --->
		select Dsaldo from Documentos 
	   where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
	</cfquery>
	<cfset saldo = rsSaldo.Dsaldo>
	
	<cfquery name="rsTot" datasource="#Session.DSN#">
		 select coalesce(sum(DFmonto),0.00) as total from DFavor 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
			  and DRdocumento != <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRdocumento#">

	</cfquery>
	<cfset tot = rsTot.total>

	<cfquery name="rsDAmonto" datasource="#Session.DSN#">
		<!--- TOMA EL MONTO DE LA LINEA ---> 
		 select DFmonto as montolinea from DFavor
		where  Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
			  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
	</cfquery>
	<cfset montolinea = rsDAmonto.montolinea>
	
	<cfset dif = #Val(Form.DFmontodoc)# - #Val(montolinea)#>
		<cfif (tot + dif) GT saldo>
			<!--- <cflocation addtoken="no" url="AplicaDocsAfavor.cfm">	 --->
			<cfset modo="CAMBIO">
			<cfset modoDet="ALTA">
			<!---<cfquery name="ABC_EAplicacionCC" datasource="#Session.DSN#">
				select <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#"> as CCTcodigo , <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#"> as Ddocumento
			</cfquery>--->
		<cfelse>
				<cf_dbtimestamp
				datasource="#session.dsn#"
				table="DFavor" 
				redirect="listaDocsAfavorCC.cfm"
				timestamp="#Form.timestampD#"
				field1="Ecodigo,integer,#Session.Ecodigo#"
				field2="CCTcodigo,char,#Form.CCTcodigo#"
				field3="Ddocumento,char,#Form.Ddocumento#"
				field4="CCTRcodigo,char,#Form.CCTRcodigo#"
				field5="DRdocumento,char,#Form.DRdocumento#">
			<cfquery datasource="#Session.DSN#">
				update DFavor set 
					DFmonto= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DFmonto#">
					,DFtotal= <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DFmonto#">
					,DFmontodoc = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DFmontodoc#">
					,DFtipocambio = <cfqueryparam cfsqltype="cf_sql_float" value="#tipocambio#">
					,SNcodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
					,Ccuenta= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaD#">
					,Mcodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.McodigoD#">
				where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and CCTcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
				  and Ddocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
				  and CCTRcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTRcodigo#">
				  and DRdocumento= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DRdocumento#">
		  </cfquery>
          
		  <cfquery datasource="#Session.DSN#">
				update EFavor set
				EFtotal=
					(select coalesce(sum(DFtotal),0.0) from DFavor
					   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						 and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
						 and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
					)          
				  where Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">
					and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ddocumento#">
			</cfquery>
		</cfif>

		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">
<cfelseif isdefined("form.SeleccionMasiva") and len(trim(form.SeleccionMasiva))>
		<cfset modo="CAMBIO">
		<cfset modoDet="ALTA">	
<cfelse>

</cfif>

<cfif isdefined("modo") and modo eq "ALTA" and isdefined("modoDet") and modoDet eq "ALTA" >
	<cfif isdefined('form.AplicaRel')>
		<cfset action = "RegistroNotasCredito.cfm">
	<cfelse>
	<cfset action = "listaDocsAfavorCC.cfm">
	</cfif>
<cfelse>
	<cfset action = "AplicaDocsAfavorPagosAnticipos.cfm">
</cfif>

<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
	<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">	
	<cfif isdefined("modo") and modo NEQ "ALTA">		
		<input name="CCTcodigo" type="hidden" value="<cfif isdefined("Form.CCTcodigo") and not isDefined("Form.BorrarE")>#Form.CCTcodigo#</cfif>">
		<input name="Ddocumento" type="hidden" value="<cfif isdefined("Form.Ddocumento") and not isDefined("Form.BorrarE")>#Form.Ddocumento#</cfif>">	
	</cfif>
	<cfif isdefined('form.AplicaRel')>
	<input name="AplicaRel" type="hidden" value="#form.AplicaRel#">
	<input name="regresa" type="hidden" value="#form.regresa#">
	</cfif>
	<cfif isdefined("Form.Aplicar")>
   		<input name="Aplicar" type="hidden" value="<cfif isdefined("Form.Aplicar")>#Form.Aplicar#</cfif>">    	
	</cfif>
	</cfoutput>

	<cfoutput>
	<input type="hidden" name="pageNum_rsDocumentos" value="<cfif isdefined('form.pageNum_rsDocumentos') and len(trim(form.pageNum_rsDocumentos))>#form.pageNum_rsDocumentos#<cfelse>1</cfif>" />
	<input type="hidden" name="descripcion" 			value="<cfif isdefined('form.descripcion') and len(trim(form.descripcion))>#form.descripcion#</cfif>" />
	<input type="hidden" name="fecha" 			value="<cfif isdefined('form.fecha') and len(trim(form.fecha)) and form.fecha neq -1 >#form.fecha#<cfelse>-1</cfif>" />
	<input type="hidden" name="transaccion" 	value="<cfif isdefined('form.transaccion') and len(trim(form.transaccion)) and form.transaccion neq -1 >#form.transaccion#<cfelse>-1</cfif>" />	
	<input type="hidden" name="usuario" 		value="<cfif isdefined('form.usuario') and len(trim(form.usuario)) and form.usuario neq -1 >#form.usuario#<cfelse>-1</cfif>" />	
	<input type="hidden" name="moneda" 			value="<cfif isdefined('form.moneda') and len(trim(form.moneda)) and form.moneda neq -1 >#form.moneda#<cfelse>-1</cfif>" />	
	</cfoutput>

</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>


