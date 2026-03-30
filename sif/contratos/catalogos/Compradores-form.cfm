<!---  --->
<!---
	Modificado por: Andres Lara
	Motivo: Nuevo catalogo de Compradores
--->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cod" Default= "C&oacute;digo:&nbsp;" XmlFile="Compradores.xml" returnvariable="LB_Cod"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Nomb" Default= "Nombre:&nbsp;" XmlFile="Compradores.xml" returnvariable="LB_Nomb"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Mon" Default= "Moneda:&nbsp;" XmlFile="Compradores.xml" returnvariable="LB_Mon"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MMax" Default= "Monto M&aacute;ximo:&nbsp;" XmlFile="Compradores.xml" returnvariable="LB_MMax"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Act" Default= "Activo" XmlFile="Compradores.xml" returnvariable="LB_Act"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_TCP" Default= "&nbsp;Tipos de Compra permitidos para el comprador&nbsp;" XmlFile="Compradores.xml" returnvariable="LB_TCP"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ART" Default= "Art&iacute;culo" XmlFile="Compradores.xml" returnvariable="LB_ART"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ACF" Default= "Activo Fijo" XmlFile="Compradores.xml" returnvariable="LB_ACF"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SERV" Default= "Servicio" XmlFile="Compradores.xml" returnvariable="LB_SERV"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OBR" Default= "Obra" XmlFile="Compradores.xml" returnvariable="LB_OBR"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MOD" Default= "Modificar" XmlFile="Compradores.xml" returnvariable="LB_MOD"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DEL" Default= "Eliminar" XmlFile="Compradores.xml" returnvariable="LB_DEL"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NEW" Default= "Nuevo" XmlFile="Compradores.xml" returnvariable="LB_NEW"/>

<cfinclude template="../../Utiles/sifConcat.cfm">
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

<!---►►Se valida que el Comprador no este Asignado a un centro Funcional,
	   ya que podria existir Solicitudes que se Asignarian a un Comprador, que ya no existe◄◄--->
<cfquery name="rsCompradorCF" datasource="#session.dsn#">
    SELECT COUNT(1) AS total
    FROM CTCompradores cp
	    INNER JOIN CFuncional cf
    		ON cp.CTCid = cf.CFcomprador
    WHERE cp.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    <cfif modo EQ "CAMBIO">
    	AND cp. CTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTCid#">
    <cfelse>
        AND 1 = 2
    </cfif>
</cfquery>

<cfquery name="rsRH" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Pcodigo = 520
</cfquery>


<cfif isdefined("Form.CTCid") and Len(Trim(Form.CTCid)) GT 0 and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif modo NEQ "ALTA">
	<!--- Recupera los valores de la tabla CTCompradores --->
	<cfquery name="rsComprador" datasource="#Session.DSN#">
		select CTCid,Ecodigo,CTCcodigo,CTCnombre,CTCactivo,CTCarticulo,CTCservicio,CTCactivofijo,CTCobra,
			   CTCMcodigo as Mcodigo,CTCmontomax,Usucodigo,BMUsucodigo
		from CTCompradores
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and CTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTCid#">
	</cfquery>

	<!--- Recupera Usucodigo para este Comprador de UsuarioReferencia --->
	<cfquery name="rsUsuario" datasource="asp">
		select Usucodigo
		from UsuarioReferencia
		where llave=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsComprador.CTCid#">
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			and STabla='CTCompradores'
	</cfquery>

</cfif>

<script src="../../js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>

<style type="text/css">
.mensajeValidacion{
		text-align:center;
		font-size:9.5px;
		font-weight:bold;
		color:C30;
	}
</style>

<form action="Compradores-sql.cfm" method="post" name="form1" onSubmit="return validar();" enctype="multipart/form-data" >
	<input type="hidden" name="BtnImagen" value="">
	<table width="100%" border="0" cellspacing="2" cellpadding="0">
		<tr>
		  <td align="right" nowrap><cfoutput><strong>#LB_Cod#</strong></cfoutput></td>
		  <td nowrap><input name="CTCcodigo" type="text" <cfif modo neq "ALTA">readonly="true"</cfif>  id="CTCcodigo" value="<cfif modo neq "ALTA"><cfoutput>#HTMLEditFormat(rsComprador.CTCcodigo)#</cfoutput></cfif>" size="10" maxlength="10" onFocus="this.select();"  alt="El C&oacute;digo del Solicitante ">
		  </td>
	  </tr>

		<tr>
      		<td align="right" nowrap><cfoutput><strong>#LB_Nomb#</strong></cfoutput></td>
      		<td nowrap>
				<cfif modo neq 'ALTA'>
						<cf_sifusuarioE conlis='false' idusuario="#rsComprador.Usucodigo#" size="40">
					<cfelse>
						<cf_sifusuarioE size="40">
				</cfif>
			</td>
    	</tr>

		<tr>
		  <td align="right"><cfoutput><strong>#LB_Mon#</strong></cfoutput></td>
		  <td><cfif modo neq 'ALTA'>
              <cf_sifmonedas query="#rsComprador#">
              <cfelse>
              <cf_sifmonedas>
            </cfif>
          </td>
	  </tr>
		<tr>
		  <td align="right" nowrap><cfoutput><strong>#LB_MMax#</strong></cfoutput></td>
		  <td><input name="CTCmontomax" type="text" value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rsComprador.CTCmontomax,'none')#<cfelse>0.00</cfif>" size="18" maxlength="18" style="text-align:right" onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" onBlur="javascript:fm(this,2);" onFocus="javascript:this.value=qf(this.value); this.select();"  >
          </td>
		</tr>

		<tr>

		  <td nowrap align="right">
            <input type="checkbox" name="CTCactivo" value="<cfif modo NEQ "ALTA">#rsComprador.CTCactivo#</cfif>" <cfif modo NEQ "ALTA" and #rsComprador.CTCactivo# EQ "1"> checked </cfif>>
          </td>
		  <td nowrap><strong>#LB_Act#</strong> </td>
		  <td>&nbsp;</td>

		</tr>

		<tr>
      		<td align="right" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2" rowspan="3" align="center" valign="middle">
			</td>
		</tr>

		<tr>
			<td align="right" nowrap>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
      		<td align="right">&nbsp;</td>
      		<td colspan="4" nowrap>
        		<fieldset style="width:95%"><legend><strong>#LB_TCP#</strong></legend>
        		<table width="100%" cellpadding="2" cellspacing="0" border="0" >
          			<tr>
            			<td>
              				<input type="checkbox" name="CTCarticulo" value="<cfif modo NEQ "ALTA">#rsComprador.CTCarticulo#</cfif>" <cfif modo NEQ "ALTA" and rsComprador.CTCarticulo EQ "1">checked</cfif> >
              				<strong>#LB_ART#</strong>
						</td>
            			<td>
              				<input type="checkbox" name="CTCactivofijo" value="<cfif modo NEQ "ALTA">#rsComprador.CTCactivofijo#</cfif>" <cfif modo NEQ "ALTA" and rsComprador.CTCactivofijo EQ "1">checked</cfif> >
              				<strong>#LB_ACF#</strong>
						</td>
            			<td>
              				<input type="checkbox" name="CTCservicio" value="<cfif modo NEQ "ALTA">#rsComprador.CTCservicio#</cfif>" <cfif modo NEQ "ALTA" and rsComprador.CTCservicio EQ "1">checked</cfif> >
              				<strong>#LB_SERV#</strong>
						</td>
							<td>
              				<input type="checkbox" name="CTCobra" value="<cfif modo NEQ "ALTA">#rsComprador.CTCobra#</cfif>" <cfif modo NEQ "ALTA" and rsComprador.CTCobra EQ "1">checked</cfif> >
              				<strong>#LB_OBR#</strong>
						</td>
          			</tr>
        		</table>
      			</fieldset>
	  		</td>
	  		<td width="100">&nbsp;</td>
    	</tr>

		<tr>
      		<td>&nbsp;</td>
      		<td colspan="4">
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="CTCid" value="#rsComprador.CTCid#">
				</cfif>
			</td>
    	</tr>

		<tr>
      		<td colspan="5" align="center">
        		<cfif modo EQ "ALTA">
          			<input type="submit" name="Alta" value="Agregar"  >
          			<input type="reset" name="Limpiar" value="Limpiar" >
          		<cfelse>
          			<input type="submit" name="Cambio" value="Modificar" onClick="javascript:cambio();">

                    <cfif rsCompradorCF.total eq 0>
                    	<input type="submit" name="Baja" value="Eliminar" onClick="javascript:if( confirm('�Desea Eliminar el Registro?') ){deshabilitarValidacion(); return true;} return false;">
          			</cfif>

                    <input type="submit" name="Nuevo" value="Nuevo"  onClick="javascript:deshabilitarValidacion();" >
        		</cfif>
      		</td>
    	</tr>

	</table>
</form>
</cfoutput>

<!---  Iframe para el conlis de tipos de Solicitud ---->
<iframe name="fr" id="fr" marginheight="0" marginwidth="0" frameborder="0" height="0" width="0" scrolling="auto" src="" ></iframe>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Nombre.required = true;
	objForm.Nombre.description="Nombre";
	objForm.CTCcodigo.required = true;
	objForm.CTCcodigo.description="Código";


	function elimina(CMUid, CTCid){
		if (!confirm('Desea eliminar el Usuario?')) return false;
			document.form1.CTCid.value = CTCid;
			document.form1.CMUid.value = CMUid;
			document.form1.submit();
	}

	function deshabilitarValidacion(){
		objForm.Nombre.required = false;
		objForm.CTCcodigo.required = false;
	}

	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height) {
		if(popUpWin) {
			if(!popUpWin.closed) {
				popUpWin.close();
			}
	  	}
	  	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function doConlisJefes() {
		popUpWindow("ConlisJefes.cfm?form=form1&usu=CMCjefe&nombre=CMCjefenom&catalogo=C",250,150,350,400);
	}

	//Funcion del conlis de tipos de solicitud
	function doConlisSolicitudes() {
		popUpWindow("conlisSolicitudes.cfm?form=form1",250,150,550,400);
	}

	//Funcion del conlis de mantenimiento firma
	function doConlisFirma() {
		popUpWindow("conlisFirma.cfm?form=form1&modo=Cambio&CTCid="+document.form1.CTCid.value,250,150,550,400);
	}

	function cambio(){

		deshabilitarValidacion();
	}

	function agregar(){
		if(document.form1.CMTScodigo.value != ''){
			document.form1.accion.value = 'insert';
			document.form1.especializacion.value = 'Agregar';
			document.form1.submit();
		}else{
			alert('Error, el campo Tipos de Solicitud es requerido')
			document.form1.especializacion.value = '';
		}
	}

	function eliminar(value){
		if ( confirm('Desea eliminar el registro?') ) {
			document.form1.accion.value = 'delete';
			document.form1.CMElinea.value = value;
			document.form1.submit();
		}
	}

	function validar(){
		//document.form1.CMCmontomax.value = qf(document.form1.CMCmontomax.value);
		return true;
	}


</script>