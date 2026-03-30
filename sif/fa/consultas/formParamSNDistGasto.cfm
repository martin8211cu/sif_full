<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" xmlfile="formParamSNDistGasto.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Distribucion" default="Distribuci&oacute;n" returnvariable="LB_Distribucion" xmlfile="formParamSNDistGasto.xml"/>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

 
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

<cfif isdefined ("Form.SNid")>
	<cfset  socio=Form.SNid>
</cfif>    

<cfquery name="rsConceptos" datasource="#Session.DSN#" >
	select distinct cf.CFformato,CFdescripcion from CtasMayor cm 
	inner join CFinanciera  cf on cm.Ecodigo=cm.Ecodigo and cm.Cmayor=cf.Cmayor
	where cf.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    and Ctipo ='G' and CFmovimiento='S'
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsCtasDG" datasource="#Session.DSN#">
		select  distinct cuenta,descripcion,SNid,porcentajeDist            
        from FAParamDistGasto
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		      and cuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.cuenta#">	
              and SNid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNid#">
	</cfquery>	
    
    <cfquery name="rsSNctsDistCim" datasource="#session.dsn#">
	select SNid from SNGastosDistribucion 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>

<cfoutput>

<form action="../consultas/SQLParamSNDistGasto.cfm" method="post" name="form1">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>#LB_Cuenta#:&nbsp;</td>
    <!---<td nowrap> <cf_sifCuentasMayor form="form1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1" size="50" tabindex="9"></td>--->
	 <cfif modo EQ "ALTA">
    <!---<td nowrap><cf_cuentas NoVerificarPres="yes" cformato="Cformato1" cdescripcion="Cdescripcion1" ccuenta="Ccuenta1" MOVIMIENTO="S" AUXILIARES="N" TIPO="G" frame="frcuenta1" descwidth="20" tabindex="5"></td> --->
                    <td>	<cf_conlis
                        	campos="CFformato,CFdescripcion"
                        	desplegables="S, S"
							Modificables="S,N" 
							Size="10,35"
							tabindex="7"
                            Tabla="CtasMayor cm inner join CFinanciera  cf on cm.Ecodigo=cm.Ecodigo and cm.Cmayor=cf.Cmayor"
                            Columnas="distinct CFformato,CFdescripcion"
							Filtro="cf.Ecodigo = #Session.Ecodigo# and Ctipo='G' and CFmovimiento='S'"
                            Desplegar="CFformato, CFdescripcion"
                            Etiquetas="Cuenta, Descripcion"                            
                            Formatos="S,S"
                            Align="left,left"
							cuenta="CFformato" 
							descripcion="CFdescripcion" 
							conexion="#Session.DSN#"
							form="form1"
                            Asignar="CFformato,CFdescripcion"
                            showEmptyListMsg="true"
                            permiteNuevo="false"
							frame="frCuentac"/>
                     </td>
  <cfelse>
  	<td nowrap>&nbsp;#form.cuenta#&nbsp;#form.descripcion#</td>
   </cfif>
  </tr>
  	<tr>
    	<td align="right" nowrap>#LB_Distribucion#: </td>
    	<td ><input size="3" type="textbox" name="txtPctjeDist" id="txtPctjeDist" <cfif (modo neq 'ALTA' and rsCtasDG.porcentajeDist GT 0)> value="#rsCtasDG.porcentajeDist#"</cfif> />%</td>
    </tr>

  <tr>
  	<td nowrap colspan="2">
		
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="CtasDistGasto" value="#rsCtasDG.cuenta#">
                <input type="hidden" name="DescCtasDistGasto" value="#rsCtasDG.descripcion#">
                <input type="hidden" name="SNid" value="#rsCtasDG.SNid#">
                <input type="hidden" name="porcentajeDist" value="#rsCtasDG.porcentajeDist#">
			</cfoutput>
         <cfelse>
         		<cfoutput><input type="hidden" name="SNid" value="#socio#">  </cfoutput> 
		</cfif>
	</td>
  </tr>
  <tr><td>&nbsp;</td></tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td nowrap align="center">
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
		<cf_templatecss>
		<cfoutput>
		<cfif modo EQ "ALTA">
			<input type="submit" name="Alta" value="#Translate('BotonAgregar','Agregar','/sif/Utiles/Generales.xml')#">
			<input type="reset" name="Limpiar" value="#Translate('BotonLimpiar','Limpiar','/sif/Utiles/Generales.xml')#">
            
		<cfelse>	
			<input type="submit" name="Cambio" value="#Translate('BotonCambiar','Modificar','/sif/Utiles/Generales.xml')#">
			<input type="submit" name="Baja" value="#Translate('BotonBorrar','Eliminar','/sif/Utiles/Generales.xml')#"> 
			<input type="submit" name="Nuevo" value="#Translate('BotonNuevo','Nuevo','/sif/Utiles/Generales.xml')#" >
		</cfif>
		</cfoutput>
<!--- 		Copiado del portlet de botones para poner funcion en el borrado --->
	</td>
  </tr>
</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	objForm.cuenta.required = true;
</script>
