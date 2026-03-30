<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select NTIcodigo, NTIdescripcion, NTIcaracteres, NTImascara
		from NTipoIdentificacion
		where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.NTIcodigo#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select rtrim(NTIcodigo) as NTIcodigo
	from NTipoIdentificacion
</cfquery>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	function codigos(obj){
		if (obj.value != "") {
			var empresa = <cfoutput>#session.Ecodigo#</cfoutput>
			var dato    = obj.value + "|" + empresa;
			var temp    = new String();
	
			<cfloop query="rsCodigos">
				temp = '<cfoutput>#rsCodigos.NTIcodigo#</cfoutput>' + "|" + empresa
				if (dato == temp){
					alert('El Código de Tipo de Identificación ya existe.');
					obj.value = "";
					obj.focus();
					return false;
				}
			</cfloop>
		}	
		return true;
	}

	function validar(){
		var f = document.form1;
		var error   = false;
		var mensaje = "Se presentaron los siguientes errores:\n\n"
		
		if( f.NTIcodigo.value == "" ){
			error   =  true;
			mensaje +=  " - " + f.NTIcodigo.alt + " es requerido.\n";
		} 

		if( f.NTIdescripcion.value == ""){
			error = true;
			mensaje +=  " - " + f.NTIdescripcion.alt + " es requerida.\n";
		} 

		if( f.NTIcaracteres.value == ""){
			error = true;
			mensaje +=  " - " + f.NTIcaracteres.alt + " es requerido.\n";
		} 

		if( f.NTImascara.value == ""){
			error = true;
			mensaje +=  " - " + f.NTImascara.alt + " es requerida.\n";
		} 

		
		if (error){
			alert(mensaje);
		}
		else{
			f.NTIcodigo.disabled = false;
		}
		
		return !error;
	}
</script>

<form name="form1" method="post" action="SQLTiposIdentificacion.cfm" onSubmit="return validar();">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="right">C&oacute;digo:&nbsp;</div></td>
      <td>
	  	<input name="NTIcodigo" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.NTIcodigo)#</cfif>" <cfif modo neq 'ALTA'>disabled</cfif> tabindex="1" size="2" maxlength="1" onblur="javascript:codigos(this);" onfocus="javascript:this.select();" alt="El C&oacute;digo de Tipo de Identificación" >
	  </td>
    </tr>
    <tr> 
      <td><div align="right">Descripci&oacute;n:&nbsp;</div></td>
      <td><input name="NTIdescripcion" type="text" tabindex="2" value="<cfif modo neq 'ALTA'>#rsForm.NTIdescripcion#</cfif>" size="70" maxlength="80" onFocus="javascript:this.select();" alt="La Descripci&oacute;n" ></td>
    </tr>
    <tr> 
      <td><div align="right">Caracteres:&nbsp;</div></td>
      <td><input name="NTIcaracteres" type="text" tabindex="2" value="<cfif modo neq 'ALTA'>#rsForm.NTIcaracteres#</cfif>" size="7" maxlength="5" onFocus="javascript:this.select();" alt="El campo Caracteres" ></td>
    </tr>

    <tr> 
      <td><div align="right">Máscara:&nbsp;</div></td>
      <td><input name="NTImascara" type="text" tabindex="2" value="<cfif modo neq 'ALTA'>#rsForm.NTImascara#</cfif>" size="40" maxlength="80" onFocus="javascript:this.select();" alt="La Máscara" ></td>
    </tr>

	<tr><td colspan="2" align="center">	
	</td></tr>
	<tr><td colspan="2" align="center"><cfinclude template="/rh/portlets/pBotones.cfm"></td></tr>

	<tr><td colspan="2" align="center">
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
        <tr> 
          <td><strong>Instrucciones para definir la máscara:</strong></td>
        </tr>
            <tr> 
              <td height="87"> <ol>
                  Indique el formato que desea de la siguiente forma: 
                  <ol>
                    <li>[*] para campos alfanuméricos (letras y números).<font color="##666699"><strong></strong></font></li>
                    <li>[x] para letras.</li>
                  </ol>
                </ol>
                <blockquote> 
                  <p>Ejemplo:</p>
                  <ul>
                    <li>&nbsp;<strong>***-** &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
                      201-ab</strong></li>
                    <li><strong>&nbsp;xxx-xx/x&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;abc-de/f</strong></li>
                    <li><strong>&nbsp;c*xx9*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;c2ab9h</strong></li>
                  </ul>
                </blockquote></td>
        </tr>
      </table>	
	</td></tr>

  </table>  
  </cfoutput>
</form>