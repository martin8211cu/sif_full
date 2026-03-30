
<!--- PRE CARGA DE VALORES --->
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif isdefined("url.ETLCid") and len(trim(url.ETLCid)) gt 0 and not isdefined("form.ETLCid")  >
	<cfset form.ETLCid = url.ETLCid>
</cfif>

<cfif isdefined("url.TLCPcedula") and len(trim(url.TLCPcedula)) gt 0 and not isdefined("form.TLCPcedula")  >
	<cfset form.TLCPcedula = url.TLCPcedula>
</cfif>
<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0 >
	<cfquery name="rs" datasource="#Session.DSN#">
		Select 	
			ETLCid,
			ETLCpatrono,     
			ETLCnomPatrono,
			ETLCespecial
		from EmpresasTLC 
		where 
			ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#" >	
	</cfquery>	
</cfif>
<cfif isdefined("rs.ETLCespecial") and  rs.ETLCespecial eq 1 >
	<cfif isdefined("form.TLCPcedula") and len(trim(form.TLCPcedula)) gt 0 >
        <cfquery name="rsPersonas" datasource="#Session.DSN#">
            select 
                TLCPcedula,
                TLCDcodigo,
                TLCPsexo,
                TLCPfechaCaduc,
                TLCPjunta,
                TLCPnombre,
                TLCPapellido1,
                TLCPapellido2
            from  TLCPadronE	
            where  TLCPcedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TLCPcedula#">		
        </cfquery>
    </cfif>
<cfelse>
	<cfquery name="rsFormato" datasource="#Session.DSN#">
		select 
            FTLCid,
            ETLCid,
            FTLCcedula,
            FTLCformato,
            FTLCnombreCKC,
            FTLCapellido1CKC,
            FTLCapellido2CKC,
            FTLCopcion1,
            FTLCopcion2,
            FTLCopcion3,
            FTLCopcion4,
            FTLCdescricion1,
            FTLCdescricion2,
            FTLCdescricion3,
            FTLCdescricion4
		from  EmpFormatoTLC	
		where  ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#" >	
	</cfquery>	
	<cfif isdefined("form.TLCPcedula") and len(trim(form.TLCPcedula)) gt 0 >
       <cfquery name="rsPersonas" datasource="#Session.DSN#">
            select 
                TLCPcedula,
                TLCPnombre,
                TLCPapellido1,
                TLCPapellido2,
                TLCPCampo1,
                TLCPCampo2,
                TLCPCampo3,
                TLCPCampo4,
                TLCPSincronizado 
            from   TLCPersonas	
            where  TLCPcedula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.TLCPcedula#">		
            and    ETLCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETLCid#" >	
        </cfquery>
    </cfif> 
</cfif>

<!--- AREA DE TRADUCCION --->
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratado_De_Libre_Comercio"
	Default="Tratado de Libre Comercio"
	returnvariable="LB_title"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Personas"
	Default="Personas"
	returnvariable="LB_Personas"/>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Informacion_De_La_Persona"
	Default="Informaci&oacute;n de la persona"
	returnvariable="LB_Informacion_De_La_Persona"/>
    
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Informacion_De_La_empresa"
	Default="Informaci&oacute;n de la empresa"
	returnvariable="LB_Informacion_De_La_empresa"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Responsable"
	Default="Responsable"
	returnvariable="LB_Responsable"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Informacion_Adicional"
	Default="Informaci&oacute;n Adicional"
	returnvariable="LB_Informacion_Adicional"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Referencia"
	Default="Referencia"
	returnvariable="LB_Referencia"/>
    
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lista_de_Distritos_Electorales"
	Default="Lista de distritos electorales"
	returnvariable="LB_Lista_de_Distritos_Electorales"/>
    

<!--- AREA DE COSULTAS --->



<!--- AREA DE FORM --->

<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
		<cfoutput>#LB_title#</cfoutput>
	</cf_templatearea>
	
<cf_templatearea name="body">
		<cf_templatecss>
		 <link href="/cfmx/sif/rh/css/rh.css" rel="stylesheet" type="text/css"><!--- --->
		<script language="JavaScript" type="text/JavaScript">
			<!--
			function MM_reloadPage(init) {  //reloads the window if Nav4 resized
				if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
				document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
				else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
			}
			MM_reloadPage(true);
			//-->
		</script>
		<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>

		<cfinclude template="../../../../sif/Utiles/params.cfm">
		<cfset regresar = "/cfmx/hosting/tratado/index.cfm">

		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Personas#'>
        
        
			<cfoutput>
			<form style="margin:0" name="form1" method="post"  action="Personas-SQL.cfm"  onSubmit="return validar();" >
				<cfif isdefined("rs.ETLCespecial") and  rs.ETLCespecial eq 1 >
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <tr><td colspan="2"><cfinclude template="../../../../sif/portlets/pNavegacion.cfm"></td></tr>
                        <tr>
                            <td valign="top" bgcolor="##A0BAD3" colspan="2">
                                <cfinclude template="frame-botones.cfm">
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <fieldset><legend>#LB_Informacion_De_La_empresa#</legend>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="2">
                                        <tr>
                                            <td nowrap="nowrap" width="15%"><font   style="font-size:10px"><cf_translate key="LB_CedulaJuridica">C&eacute;dula Jur&iacute;dica</cf_translate></font></td>
                                            <td nowrap="nowrap"><font  >#rs.ETLCpatrono#</font></td>
                                        </tr>
                                        <tr>
                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Nombre_Patronal">Nombre Patronal</cf_translate></font></td>
                                            <td nowrap="nowrap"><font  >#rs.ETLCnomPatrono#</font></td>
                                        </tr>
                                        
                                        
                                    </table>
                                 </fieldset>   
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <fieldset>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                        <tr>
                                            <td colspan="2">
                                                <fieldset><legend>#LB_Informacion_De_La_Persona#</legend>
                                                    <table width="100%" border="0" cellpadding="0" cellspacing="2">
                                                        <tr>
                                                            <td nowrap="nowrap"><font   style="font-size:10px"><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate></font></td>
                                                            <td>
                                                                <input 
                                                                    name="TLCPcedula" 
                                                                    type="text" 
                                                                    id="TLCPcedula"  
                                                                    tabindex="1"
                                                                    maxlength="9"
                                                                    size="15"
                                                                    <cfif isdefined("rsPersonas.TLCPcedula") and len(trim(rsPersonas.TLCPcedula))> readonly</cfif>
                                                                    value="<cfif isdefined("rsPersonas.TLCPcedula") and len(trim(rsPersonas.TLCPcedula))>#rsPersonas.TLCPcedula#</cfif>">
                                                            </td>
                                                            <td>&nbsp;
                                                                 
                                                            </td>
                                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Sexo">Sexo</cf_translate></font></td>
                                                            <td colspan="4">
                                                                <select name="TLCPsexo">
                                                                    <option value="1"  <cfif isdefined("rsPersonas.TLCPsexo") and rsPersonas.TLCPsexo eq 1> selected </cfif>  ><cf_translate key="LB_Masculino">Masculino</cf_translate></option>
                                                                    <option value="2"  <cfif isdefined("rsPersonas.TLCPsexo") and rsPersonas.TLCPsexo eq 2> selected </cfif> ><cf_translate key="LB_Femenino">Femenino</cf_translate></option>
    
                                                                </select>
    
                                                            </td>		
                                                        </tr>
                                                        <tr>
                                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Nombre">Nombre</cf_translate></font>&nbsp;</td>
                                                            <td>
                                                                <input 
                                                                    name="TLCPnombre" 
                                                                    type="text" 
                                                                    id="TLCPnombre"  
                                                                    tabindex="1"
                                                                    maxlength="100"
                                                                    size="35"
                                                                    value="<cfif isdefined("rsPersonas.TLCPnombre") and len(trim(rsPersonas.TLCPnombre))>#rsPersonas.TLCPnombre#</cfif>">
                                                            </td>
                                                            <td>&nbsp;</td>
                                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Primer_Apellido">Primer Apellido</cf_translate></font>&nbsp;</td>
                                                            <td>
                                                                <input 
                                                                    name="TLCPapellido1" 
                                                                    type="text" 
                                                                    id="TLCPapellido1"  
                                                                    tabindex="1"
                                                                    maxlength="80"
                                                                    size="30"
                                                                    value="<cfif isdefined("rsPersonas.TLCPapellido1") and len(trim(rsPersonas.TLCPapellido1))>#rsPersonas.TLCPapellido1#</cfif>">
                                                            </td>
                                                            <td>&nbsp;</td>
                                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Segundo_Apellido">Segundo Apellido</cf_translate></font>&nbsp;</td>
                                                            <td>
                                                                <input 
                                                                    name="TLCPapellido2" 
                                                                    type="text" 
                                                                    id="TLCPapellido2"  
                                                                    tabindex="1"
                                                                    maxlength="80"
                                                                    size="30"
                                                                    value="<cfif isdefined("rsPersonas.TLCPapellido2") and len(trim(rsPersonas.TLCPapellido2))>#rsPersonas.TLCPapellido2#</cfif>">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Caducidad">Caducidad</cf_translate></font>&nbsp;</td>
                                                            <td>
                                                                <cfif (isDefined("rsPersonas.TLCPfechaCaduc")) and (len(trim(rsPersonas.TLCPfechaCaduc)) gt 0)>
                                                                    <cfoutput>
                                                                        <cf_sifcalendario name="TLCPfechaCaduc" value="#LSDateFormat(rsPersonas.TLCPfechaCaduc, "dd/mm/yyyy")#" tabindex="1">
                                                                    </cfoutput>
                                                                <cfelse>
                                                                    <cf_sifcalendario name="TLCPfechaCaduc" tabindex="1">
                                                                </cfif>
    
                                                            </td>
                                                            <td>&nbsp;</td>
                                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Junta">Junta</cf_translate></font>&nbsp;</td>
                                                            <td>
                                                                <input 
                                                                    name="TLCPjunta" 
                                                                    type="text" 
                                                                    id="TLCPjunta"  
                                                                    tabindex="1"
                                                                    maxlength="5"
                                                                    size="10"
                                                                    value="<cfif isdefined("rsPersonas.TLCPjunta") and len(trim(rsPersonas.TLCPjunta))>#rsPersonas.TLCPjunta#</cfif>">
                                                            </td>
                                                            <td colspan="3">&nbsp;</td>
                                                        </tr>
                                                        
                                                        
                                                        <tr>
                                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Distrito_Electoral">Distrito Electoral</cf_translate></font>&nbsp;</td>
                                                            <td colspan="7">
                                                                <cfset ArrayDELEC=ArrayNew(1)>
                                                                <cfif isdefined("rsPersonas.TLCDcodigo") and len(trim(rsPersonas.TLCDcodigo))>
                                                                    <cfquery name="rsDELEC" datasource="#session.DSN#">
                                                                        select TLCDcodigo,TLCDProvincia,TLCDCanton,TLCDDistrito
                                                                        from TLCDistritoE
                                                                        where TLCDcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPersonas.TLCDcodigo#"> 
                                                                    </cfquery>
                                                                    <cfset ArrayAppend(ArrayDELEC,rsDELEC.TLCDcodigo)>
                                                                    <cfset ArrayAppend(ArrayDELEC,rsDELEC.TLCDProvincia)>
                                                                    <cfset ArrayAppend(ArrayDELEC,rsDELEC.TLCDCanton)>
                                                                    <cfset ArrayAppend(ArrayDELEC,rsDELEC.TLCDDistrito)>
                                                                </cfif>
                                                                <cf_conlis
                                                                    Campos="TLCDcodigo,TLCDProvincia,TLCDCanton,TLCDDistrito"
                                                                    Desplegables="S,S,S,S"
                                                                    Modificables="S,N,N,N"
                                                                    Size="7,30,30,30"
                                                                    tabindex="1"
                                                                    ValuesArray="#ArrayDELEC#" 
                                                                    Title="#LB_Lista_de_Distritos_Electorales#"
                                                                    Tabla="TLCDistritoE"
                                                                    Columnas="TLCDcodigo,TLCDProvincia,TLCDCanton,TLCDDistrito"
                                                                    Desplegar="TLCDcodigo,TLCDProvincia,TLCDCanton,TLCDDistrito"
                                                                    Etiquetas="Codigo,Provincia,Canton,Distrito"
                                                                    filtrar_por="TLCDcodigo,TLCDProvincia,TLCDCanton,TLCDDistrito"
                                                                    Formatos="S,S,S,S"
                                                                    Align="left,left,left,left"
                                                                    form="form1"
                                                                    Asignar="TLCDcodigo,TLCDProvincia,TLCDCanton,TLCDDistrito"
                                                                    Asignarformatos="S,S,S,S"/>
                                                            </td>
                                                        </tr>
                                                        
                                                    </table>
                                                </fieldset>
                                            </td>	
                                        <tr>
                                        <tr>
                                    </table>
                                </fieldset>	
                            </td>
                        </tr>	
                    </table>
                 <cfelse>
                	<table width="100%" cellpadding="0" cellspacing="0">
                        <tr><td colspan="2"><cfinclude template="../../../../sif/portlets/pNavegacion.cfm"></td></tr>
                        <tr>
                            <td valign="top" bgcolor="##A0BAD3" colspan="2">
                                <cfinclude template="frame-botones.cfm">
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">
                                <fieldset><legend>#LB_Informacion_De_La_empresa#</legend>
                                    <table width="100%" border="0" cellpadding="0" cellspacing="2">
                                        <tr>
                                            <td nowrap="nowrap" width="15%"><font   style="font-size:10px"><cf_translate key="LB_CedulaJuridica">C&eacute;dula Jur&iacute;dica</cf_translate></font></td>
                                            <td nowrap="nowrap"><font  >#rs.ETLCpatrono#</font></td>
                                        </tr>
                                        <tr>
                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Nombre_Patronal">Nombre Patronal</cf_translate></font></td>
                                            <td nowrap="nowrap"><font  >#rs.ETLCnomPatrono#</font></td>
                                        </tr>
                                    </table>
                                 </fieldset>   
                            </td>
                        </tr>                        
                        <tr>
                        	 <td valign="top">
                             <fieldset>
                             	<table width="100%" border="0" cellpadding="0" cellspacing="2">
                                	<cfif isdefined("rsPersonas.TLCPcedula") and len(trim(rsPersonas.TLCPcedula))>
                                 	<tr>  
                                        <td nowrap="nowrap" width="15%"><font   style="font-size:10px"><cf_translate key="LB_Sincronizado">Sincronizado</cf_translate> </td>
                                        <td>
                                            <font   style="font-size:10px">
											<cfif rsPersonas.TLCPSincronizado  eq  0>
                                            	<cf_translate key="LB_No">No</cf_translate>
                                            <cfelse>
                                            	<cf_translate key="LB_Si">Si</cf_translate>
											</cfif> 
                                            </font>                                     
                                        </td>
                                     </tr>
                                    </cfif> 
                                
                                     <tr>  
                                        <td nowrap="nowrap" width="15%"><font   style="font-size:10px"><cf_translate key="LB_Cedula">C&eacute;dula</cf_translate> </td>
                                        <td>
                                            <cfif not isdefined("rsPersonas.TLCPcedula") >
                                                <input 
                                                    name="TLCPcedula" 
                                                    type="text" 
                                                    id="TLCPcedula"  
                                                    tabindex="1"
                                                    maxlength="50"
                                                    size="35"
                                                    style="font-size:10px"  
                                                    value="">
                                                    <font   style="font-size:10px">
														<cfif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 1>
                                                              <cf_translate key="MSG_ejemplo_cedula1">C&eacute;dula con 9 d&iacute;gitos, ejemplo 102340567</cf_translate>
                                                        <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 2>
                                                              <cf_translate key="MSG_ejemplo_cedula2">C&eacute;dula con 7 d&iacute;gitos, ejemplo 1234567</cf_translate>
                                                        <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 3>
                                                              <cf_translate key="MSG_ejemplo_cedula3">C&eacute;dula con 9 d&iacute;gitos y separador, ejemplo 1-0234-0567</cf_translate>
                                                        <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 4>
                                                              <cf_translate key="MSG_ejemplo_cedula4">C&eacute;dula con 7 d&iacute;gitos y separador, ejemplo 1-234-567</cf_translate>
                                                        </cfif>                                                    
                                                    </font>
                                            <cfelse>
                                            	<font   style="font-size:10px">#rsPersonas.TLCPcedula#&nbsp;</font>
                                                <input name="TLCPcedula" type="hidden" id="TLCPcedula" value="#rsPersonas.TLCPcedula#">
                                            </cfif>                                                
                                        </td>
                                     </tr>  
                                     <cfif isdefined("rsFormato.FTLCnombreCKC") and rsFormato.FTLCnombreCKC eq 1>	
                                     	<tr>  
                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Nombre">Nombre</cf_translate></font>&nbsp;</td>
                                            <td>
                                                <input 
                                                    name="TLCPnombre" 
                                                    type="text" 
                                                    id="TLCPnombre"  
                                                    tabindex="1"
                                                    maxlength="100"
                                                    size="35"
                                                    style="font-size:10px"  
                                                    value="<cfif isdefined("rsPersonas.TLCPnombre") and len(trim(rsPersonas.TLCPnombre))>#trim(rsPersonas.TLCPnombre)#</cfif>">
                                            </td>
                                     </tr>  
                                    </cfif> 
                                    <cfif isdefined("rsFormato.FTLCapellido1CKC") and rsFormato.FTLCapellido1CKC eq 1>	
                                        </tr>  
                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Primer_Apellido">Primer Apellido</cf_translate></font>&nbsp;</td>
                                            <td>
                                                <input 
                                                    name="TLCPapellido1" 
                                                    type="text" 
                                                    id="TLCPapellido1"  
                                                    tabindex="1"
                                                    maxlength="80"
                                                    size="35"
                                                    style="font-size:10px"  
                                                    value="<cfif isdefined("rsPersonas.TLCPapellido1") and len(trim(rsPersonas.TLCPapellido1))>#trim(rsPersonas.TLCPapellido1)#</cfif>">
                                            </td> 
                                        </tr>  
                                    </cfif>
                                    <cfif isdefined("rsFormato.FTLCapellido2CKC") and rsFormato.FTLCapellido2CKC eq 1>	
                                        </tr>  
                                            <td  nowrap="nowrap"><font  style="font-size:10px"><cf_translate key="LB_Segundo_Apellido">Segundo Apellido</cf_translate></font>&nbsp;</td>
                                            <td>
                                                <input 
                                                    name="TLCPapellido2" 
                                                    type="text" 
                                                    id="TLCPapellido2"  
                                                    tabindex="1"
                                                    maxlength="80"
                                                    size="35"
                                                    style="font-size:10px"  
                                                    value="<cfif isdefined("rsPersonas.TLCPapellido2") and len(trim(rsPersonas.TLCPapellido2))>#trim(rsPersonas.TLCPapellido2)#</cfif>">
                                            </td> 
                                        </tr>                                     
									</cfif> 
                                    <cfif isdefined("rsFormato.FTLCopcion1") and rsFormato.FTLCopcion1 eq 1>	
                                        </tr>  
                                            <td  nowrap="nowrap"><font  style="font-size:10px">#rsFormato.FTLCdescricion1#</font>&nbsp;</td>
                                            <td>
                                                <input 
                                                    name="TLCPCampo1" 
                                                    type="text" 
                                                    id="TLCPCampo1"  
                                                    tabindex="1"
                                                    maxlength="80"
                                                    size="35"
                                                    style="font-size:10px"  
                                                    value="<cfif isdefined("rsPersonas.TLCPCampo1") and len(trim(rsPersonas.TLCPCampo1))>#trim(rsPersonas.TLCPCampo1)#</cfif>">
                                                    <font  style="font-size:10px"><cf_translate key="LB_Referencia">(Referencia)</cf_translate></font>
                                            </td> 
                                        </tr>                                     
									</cfif>   
                                     <cfif isdefined("rsFormato.FTLCopcion2") and rsFormato.FTLCopcion2 eq 1>	
                                        </tr>  
                                            <td  nowrap="nowrap"><font  style="font-size:10px">#rsFormato.FTLCdescricion2#</font>&nbsp;</td>
                                            <td>
                                                <input 
                                                    name="TLCPCampo2" 
                                                    type="text" 
                                                    id="TLCPCampo2"  
                                                    tabindex="1"
                                                    maxlength="80"
                                                    size="35"
                                                    style="font-size:10px"  
                                                    value="<cfif isdefined("rsPersonas.TLCPCampo2") and len(trim(rsPersonas.TLCPCampo2))>#trim(rsPersonas.TLCPCampo2)#</cfif>">
                                            </td> 
                                        </tr>                                     
									</cfif>  
                                     <cfif isdefined("rsFormato.FTLCopcion3") and rsFormato.FTLCopcion3 eq 1>	
                                        </tr>  
                                            <td  nowrap="nowrap"><font  style="font-size:10px">#rsFormato.FTLCdescricion3#</font>&nbsp;</td>
                                            <td>
                                                <input 
                                                    name="TLCPCampo3" 
                                                    type="text" 
                                                    id="TLCPCampo3"  
                                                    tabindex="1"
                                                    maxlength="80"
                                                    size="35"
                                                    style="font-size:10px"  
                                                    value="<cfif isdefined("rsPersonas.TLCPCampo3") and len(trim(rsPersonas.TLCPCampo3))>#trim(rsPersonas.TLCPCampo3)#</cfif>">
                                            </td> 
                                        </tr>                                     
									</cfif>                                  
 									<cfif isdefined("rsFormato.FTLCopcion4") and rsFormato.FTLCopcion4 eq 1>	
                                        </tr>  
                                            <td  nowrap="nowrap"><font  style="font-size:10px">#rsFormato.FTLCdescricion4#</font>&nbsp;</td>
                                            <td>
                                                <input 
                                                    name="TLCPCampo4" 
                                                    type="text" 
                                                    id="TLCPCampo4"  
                                                    tabindex="1"
                                                    maxlength="80"
                                                    size="35"
                                                    style="font-size:10px"  
                                                    value="<cfif isdefined("rsPersonas.TLCPCampo4") and len(trim(rsPersonas.TLCPCampo4))>#trim(rsPersonas.TLCPCampo4)#</cfif>">
                                            </td> 
                                        </tr>                                     
									</cfif>                                
                                </table>
                             </fieldset>
                             </td>
                        </tr>
                 	</table>      
				 </cfif>
                 
                 <cfif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 1>
                     <input name="FTLCformato" type="hidden" id="FTLCformato" value="##################">
                 <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 2>
                     <input name="FTLCformato" type="hidden" id="FTLCformato" value="##############">
                 <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 3>
                     <input name="FTLCformato" type="hidden" id="FTLCformato" value="##-########-########">
                 <cfelseif isdefined("rsFormato.FTLCformato") and rsFormato.FTLCformato eq 4>
                     <input name="FTLCformato" type="hidden" id="FTLCformato" value="##-######-######">
                 </cfif>
                <input name="ETLCespecial" type="hidden" id="ETLCespecial" value="<cfif isdefined("rs.ETLCespecial") and len(trim(rs.ETLCespecial)) gt 0 >#rs.ETLCespecial#</cfif>">
				<input name="ETLCid" type="hidden" id="ETLCid" value="<cfif isdefined("form.ETLCid") and len(trim(form.ETLCid)) gt 0 >#rs.ETLCid#</cfif>">
				<input name="AccionAEjecutar" type="hidden" id="AccionAEjecutar" value="">
			</form>
			</cfoutput>
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Cedula_es_requerido"
Default="Cedula es requerido"
returnvariable="LB_Cedula_es_requerido"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Nombre_es_requerido"
    Default="Nombre  es requerido"
    returnvariable="LB_Nombre_es_requerido"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Primer_Apellido_es_requerido"
    Default="Primer Apellido  es requerido"
    returnvariable="LB_Primer_Apellido_es_requerido"/>

<cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="LB_Segundo_Apellido_es_requerido"
    Default="Segundo Apellido  es requerido"
    returnvariable="LB_Segundo_Apellido_es_requerido"/>

<cfif isdefined("rs.ETLCespecial") and  rs.ETLCespecial eq 1 >
    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Caducidad_es_requerido"
        Default="Caducidad  es requerido"
        returnvariable="LB_Caducidad_es_requerido"/>

    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Junta_es_requerido"
        Default="Junta  es requerido"
        returnvariable="LB_Junta_es_requerido"/>

    <cfinvoke component="sif.Componentes.Translate"
        method="Translate"
        Key="LB_Distrito_Electoral_es_requerido"
        Default="Distrito Electoral  es requerido"
        returnvariable="LB_Distrito_Electoral_es_requerido"/>
<cfelse>
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="MSG_es_requerido"
    Default="es requerido"	
    returnvariable="MSG_es_requerido"/>
    
    <cfinvoke component="sif.Componentes.Translate"
    method="Translate"
    Key="MSG_El_formato_de_la_cedula_no_es_valido"
    Default="El formato de la cedula no es valido"	
    returnvariable="MSG_El_formato_de_la_cedula_no_es_valido"/>    
    
</cfif>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MSG_PorFavorReviseLosSiguienteDatos"
Default="Por favor revise los siguiente datos"	
returnvariable="MSG_PorFavorReviseLosSiguienteDatos"/>



<script language="javascript" type="text/javascript">
	<!--//
	<cfoutput>
	
	function validar(){
		var error_msg = '';
		

		<cfif isdefined("rs.ETLCespecial") and  rs.ETLCespecial eq 1 > 
			if (document.form1.TLCPcedula.value == ""){
				error_msg += "\n - <cfoutput>#LB_Cedula_es_requerido#</cfoutput>.";
			}

			if (document.form1.TLCPnombre.value == ""){
				error_msg += "\n - <cfoutput>#LB_Nombre_es_requerido#</cfoutput>.";
			}		
		
			if (document.form1.TLCPapellido1.value == ""){
				error_msg += "\n - <cfoutput>#LB_Primer_Apellido_es_requerido#</cfoutput>.";
			}		

			if (document.form1.TLCPapellido2.value == ""){
				error_msg += "\n - <cfoutput>#LB_Segundo_Apellido_es_requerido#</cfoutput>.";
			}		


			if (document.form1.TLCPfechaCaduc.value == ""){
				error_msg += "\n - <cfoutput>#LB_Caducidad_es_requerido#</cfoutput>.";
			}	
			
			if (document.form1.TLCPjunta.value == ""){
				error_msg += "\n - <cfoutput>#LB_Junta_es_requerido#</cfoutput>.";
			}		


			if (document.form1.TLCDcodigo.value == ""){
				error_msg += "\n - <cfoutput>#LB_Distrito_Electoral_es_requerido#</cfoutput>.";
			}	
		<cfelse>
			if (document.form1.TLCPcedula.value == ""){
				error_msg += "\n - <cfoutput>#LB_Cedula_es_requerido#</cfoutput>.";
			}
			
			<cfif not isdefined("rsPersonas.TLCPcedula")>
				if ( mask(document.form1.TLCPcedula.value, document.form1.FTLCformato.value) == false){
					error_msg += "\n - <cfoutput>#MSG_El_formato_de_la_cedula_no_es_valido#</cfoutput>.";
				}
			</cfif> 
			
			<cfif isdefined("rsFormato.FTLCnombreCKC") and rsFormato.FTLCnombreCKC eq 1>	
				if (document.form1.TLCPnombre.value == ""){
					error_msg += "\n - <cfoutput>#LB_Nombre_es_requerido#</cfoutput>.";
				}
			</cfif> 
			<cfif isdefined("rsFormato.FTLCapellido1CKC") and rsFormato.FTLCapellido1CKC eq 1>	
				if (document.form1.TLCPapellido1.value == ""){
					error_msg += "\n - <cfoutput>#LB_Primer_Apellido_es_requerido#</cfoutput>.";
				}		
			</cfif>
			<cfif isdefined("rsFormato.FTLCapellido2CKC") and rsFormato.FTLCapellido2CKC eq 1>	
				if (document.form1.TLCPapellido2.value == ""){
					error_msg += "\n - <cfoutput>#LB_Segundo_Apellido_es_requerido#</cfoutput>.";
				}		
			</cfif> 
			<cfif isdefined("rsFormato.FTLCopcion1") and rsFormato.FTLCopcion1 eq 1>
				if (document.form1.TLCPCampo1.value == ""){
					error_msg += "\n - <cfoutput>#rsFormato.FTLCdescricion1# #MSG_es_requerido#</cfoutput>.";
				}	
			</cfif>   
			<cfif isdefined("rsFormato.FTLCopcion2") and rsFormato.FTLCopcion2 eq 1>	
				if (document.form1.TLCPCampo2.value == ""){
					error_msg += "\n - <cfoutput>#rsFormato.FTLCdescricion2# #MSG_es_requerido#</cfoutput>.";
				}	
			</cfif>  
			<cfif isdefined("rsFormato.FTLCopcion3") and rsFormato.FTLCopcion3 eq 1>	
				if (document.form1.TLCPCampo3.value == ""){
					error_msg += "\n - <cfoutput>#rsFormato.FTLCdescricion3# #MSG_es_requerido#</cfoutput>.";
				}	
			</cfif>                                  
			<cfif isdefined("rsFormato.FTLCopcion4") and rsFormato.FTLCopcion4 eq 1>	
				if (document.form1.TLCPCampo4.value == ""){
					error_msg += "\n - <cfoutput>#rsFormato.FTLCdescricion4# #MSG_es_requerido#</cfoutput>.";
				}				</cfif>  
		
		</cfif>
		if (error_msg.length != "") {
			alert("<cfoutput>#MSG_PorFavorReviseLosSiguienteDatos#</cfoutput>:"+error_msg);
			return false;
		}
		return true;	
	
	}

	function funcAgregar(){
		if(validar()){
			document.form1.AccionAEjecutar.value="AGREGAR";
			document.form1.submit();
		}
	}
	
	function funcLimpiar(){
		document.form1.reset();
	}	

	function funcRegresar(){
		location.href ='Personas-lista.cfm?ETLCid=#FORM.ETLCid#';
		
	}
	
	function funcModificar(){
		if(validar()){
			document.form1.AccionAEjecutar.value="MODIFICAR";
			document.form1.submit();
		}
	}

	function funcEliminar(){
		document.form1.AccionAEjecutar.value="ELIMINAR";
		document.form1.submit();
	}	
	
	function funcNuevo(){
		document.form1.AccionAEjecutar.value="NUEVO";
		document.form1.submit();
	}
	
	function mask (InString, Mask)  {
		LenStr = InString.length;
		LenMsk = Mask.length;
		
		if ((LenStr==0) || (LenMsk==0))
			return(false);
		if (LenStr!=LenMsk)
			return(false);
		TempString=""
		for (Count=0; Count<=InString.length; Count++)  {
			StrChar = InString.substring(Count, Count+1);
			MskChar = Mask.substring(Count, Count+1);
			if (MskChar=="##") {
				if(!isNumberChar(StrChar)){
					return(false);
				}	
			}
			else if (MskChar=='?') {
				if(!isAlphabeticChar(StrChar)){
					return(false);
				}	
			}
			else if (MskChar=='!') {
				if(!isNumOrChar(StrChar)){
					return(false);
				}	
			}
			else if (MskChar=='*') {
			}
			else {
				if (MskChar!=StrChar) {
					return(false);
				}	
			}
		}
		return (true);
	}
	function isAlphabeticChar (InString)  {
		if(InString.length!=1) 
			return (false);
		InString=InString.toLowerCase();
		RefString="abcdefghijklmnopqrstuvwxyz";
		if (RefString.indexOf (InString.toLowerCase(), 0)==-1) 
			return (false);
		return (true);
	}
	function isNumberChar (InString)  {
		if(InString.length!=1) 
			return (false);
		RefString="1234567890";
		if (RefString.indexOf (InString, 0)==-1) 
			return (false);
		return (true);
	}
	function isNumOrChar (InString)  {
		if(InString.length!=1) 
			return (false);
		InString=InString.toLowerCase();
		RefString="1234567890abcdefghijklmnopqrstuvwxyz";
		if (RefString.indexOf (InString, 0)==-1)  
			return (false);
		return (true);
	}
	
	
	</cfoutput>	
	//-->
</script>