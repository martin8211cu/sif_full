<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined("url.RHEid") and len(trim(url.RHEid)) and not isdefined("form.RHEid")>
	<cfset form.RHEid = url.RHEid>
</cfif>

<!---Verificar si ya se calculo el escenario----->
<cfquery name="rsVerificaCalculo" datasource="#session.DSN#">
	select coalesce(count(1),0) as CalculoEscenario
	from RHFormulacion
	where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and exists(select 1 from RHSituacionActual
					where RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
						and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) 
</cfquery>
<!--- ************************* CONSULTAS ********************* --->
<!--- CONSULTA DE LOS DATOS --->
<cfquery name="rsCargas" datasource="#session.DSN#">
	select RHEid,b.ECid,b.DClinea,
        ltrim(rtrim(ECcodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(ECdescripcion)) as Encabezado,	
        ltrim(rtrim(DCcodigo))#LvarCNCT#' - '#LvarCNCT#ltrim(rtrim(DCdescripcion)) as Detalle,	
        a.RHECPvalor as Valor,RHECPmetodo,RHECPaplicaCargas
    from RHECargasPatronales a
    inner join DCargas b
        on b.Ecodigo = a.Ecodigo
        and b.DClinea = a.DClinea
    inner join ECargas c
        on c.ECid = b.ECid
        and c.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
    <cfif isdefined('form.Filtrar')>
    	<cfif isdefined('form.Filtro_Codigo') and LEN(TRIM(form.Filtro_Codigo)) GT 0>
        	and  upper(ltrim(rtrim(DCcodigo))) like ('%#ucase(form.Filtro_Codigo)#%')
        </cfif>
        <cfif isdefined('form.Filtro_Detalle') and LEN(TRIM(form.Filtro_Detalle)) GT 0>
        	and  upper(ltrim(rtrim(DCdescripcion))) like ('%#ucase(form.Filtro_Detalle)#%')
        </cfif>
        <cfif isdefined('form.Filtro_Valor') and LEN(TRIM(form.Filtro_Valor)) GT 0>
        	and RHECPvalor = <cfqueryparam cfsqltype="cf_sql_float" value="#form.Filtro_Valor#">
        </cfif>
    </cfif>
    order by Encabezado,Detalle
</cfquery>
<!--- ************************* FIN CONSULTAS ********************* --->


<!----Fechas del escenario--->
<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
	<cfquery name="rsEscenario" datasource="#session.DSN#">	
		select RHEfdesde, RHEfhasta from RHEscenarios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEid#">
	</cfquery>
</cfif>


<script type="text/javascript" language="javascript1.2">
	function funcImportar(){
		var vrs_verifica = <cfoutput>#rsVerificaCalculo.CalculoEscenario#</cfoutput>;
		if (vrs_verifica == 0){
			if(confirm('¿Esta seguro que desea importar las cargas patronales?')){
				document.formCargasP.action = 'SA-CargasPatronales-sql.cfm';
				return true;
			}
			return false;
		}
		else{
			if(confirm('Ya se ha calculado el escenario.  ¿Esta seguro que desea importar las cargas patronales y perder los datos?')){
				document.formCargasP.action = 'SA-CargasPatronales-sql.cfm';
				return true;
			}
			return false			
		}
	}
	function funcGuardar(){
		var vrs_verifica = <cfoutput>#rsVerificaCalculo.CalculoEscenario#</cfoutput>;
		if (vrs_verifica == 0){
			if(confirm('¿Desea modificar los datos de las cargas patronales?')){
				document.formCargasP.action = 'SA-CargasPatronales-sql.cfm';
				return true;
			}
			return false;
		}
		else{
			if(confirm('Ya se ha calculado el escenario.  ¿Desea modificar los datos de las cargas patronales y perder los datos?')){
				document.formCargasP.action = 'SA-CargasPatronales-sql.cfm';
				return true;
			}
			return false			
		}
	}
	
	function funcLimpiar(){
		document.formCargasP.filtro_Codigo.value = '';	
		document.formCargasP.filtro_Detalle.value = '';	
		document.formCargasP.filtro_Valor.value = '';	
		return true;
	}
</script>
<cf_templatecss>

<form name="formCargasP" method="post" action="">
<cfoutput>
	<input type="hidden" name="RHEid" 	value="<cfif isdefined("form.RHEid") and len(trim(form.RHEid))>#form.RHEid#</cfif>">
	<input type="hidden" name="RHEfdesde" 	value="<cfif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfdesde#</cfif>">
	<input type="hidden" name="RHEfhasta" 	value="<cfif isdefined("rsEscenario") and rsEscenario.recordCount NEQ 0>#rsEscenario.RHEfhasta#</cfif>">
</cfoutput>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center" >  
	  <tr class="tituloListas" >
		<td>
			<strong style="color:##003366; font-family:'Times New Roman', Times, serif; font-size:13pt; font-variant:small-caps; font-weight:bolder;">Cargas Patronales</strong>		
		</td>		
		<td nowrap="nowrap" align="right" valign="top">
			<cf_botones names="Importar,Guardar" values="Importar,Modificar">
        </td> 
        <td>
            <img style="cursor:pointer;" src="/cfmx/sif/imagenes/Help02_T.gif" onclick="javascrip:popUpWindowimgAyuda();"/>
		</td>
	  </tr>
	  <tr><td class="tituloListas" colspan="3">&nbsp;</td></tr>
	  <tr>
		<td valign="top" colspan="3">
			<fieldset>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">							
				<tr>
                	<td >
                        <table width="65%" border="0" cellpadding="0" cellspacing="0" align="center">
                        	<tr  class="tituloListas">
                            	<td><strong><cf_translate key="LB_Codigo">C&oacute;digo</cf_translate></strong></td>
                                <td><strong><cf_translate key="LB_Descripcion">Descripci&oacute;n</cf_translate></strong></td>
                                <td align="right"><strong><cf_translate key="LB_Valor">Valor</cf_translate></strong></td>
                                <td>&nbsp;</td>
                           	</tr>
                            <cfoutput>
                            <tr  class="tituloListas">
                            	<td><input name="filtro_Codigo" type="text" value="" size="10" /></td>
                                <td><input name="filtro_Detalle" type="text" value="" size="30" /></td>
                                <td align="right"><cf_inputNumber name="filtro_Valor" value="" decimales="2" modificable="true" tabindex="1"></td>
                                <td><cf_botones names="Filtrar" values="Filtrar"></td>
                           	</tr>
                            </cfoutput>
                        </table>
                  	</td>
                  </tr>
                  <tr>
                  	<td>
                    	<table width="65%" border="0" cellpadding="0" cellspacing="0" align="center">
                            <cfoutput query="rsCargas" group="Encabezado">
                            	<cfif rsCargas.RHECPmetodo EQ 1><cfset Lvar_Enteros = 2><cfelse><cfset Lvar_Enteros = 6></cfif>
								<tr class="corteLista"><td colspan="3"><strong>#Encabezado#</strong></td></tr>
                                <cfoutput>
								<tr class="<cfif rsCargas.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
                                	<td><input name="RHECPaplicaCargas#DClinea#" type="checkbox" title="Aplicar cargas" <cfif rsCargas.RHECPaplicaCargas EQ 1>checked</cfif>></td>
                                	<td>#Detalle#</td>
                                    <td align="right"><cf_inputNumber name="Valor#DClinea#" value="#Valor#" decimales="2" modificable="true" tabindex="1" enteros="#Lvar_Enteros#"></td>
                                    <td>&nbsp;</td>
                                </tr>
								</cfoutput>
							</cfoutput>
                        </table>
					</td>
                </tr>						
			</table>	
			</fieldset>	
		</td>
	  </tr>
	  <tr><td>&nbsp;</td></tr>
	</table>
</form>
<script>
var popUpWinimgAyuda=0;
	function popUpWindowimgAyuda(){
		ww = 650;
		wh = 450;
		wl = 250;
		wt = 200;
	
		if(popUpWinimgAyuda){
			if(!popUpWinimgAyuda.closed) popUpWinimgAyuda.close();
		}
	
		popUpWinimgAyuda = open('/cfmx/rh/planillap/operacion/Escenarios-ayuda.cfm?tipo=6', 'popUpWinimgAyuda', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width='+ww+',height='+wh+',left='+wl+', top='+wt+',screenX='+wl+',screenY='+wt+'');			
	}
</script>