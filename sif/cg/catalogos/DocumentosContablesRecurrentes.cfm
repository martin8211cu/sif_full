	<!--- Filtros para consulta--->
	<cfset filtro="">
	<cfif isdefined('form.Fdescripcion') and len(trim(form.Fdescripcion)) GT 0>
		<cfset filtro=filtro &  "and upper(h.Edescripcion) like '%" & ucase(form.Fdescripcion) & "%'">
	</cfif>
	<cfif isdefined('form.IfechaGen') and len(trim(form.IfechaGen)) GT 0>
		<cf_dbfunction name="date_format" args="h.ECfechacreacion,DD/MM/YYYY" returnvariable="VFFecha1">
		<cf_dbfunction name="date_format" args="#form.IfechaGen#,DD/MM/YYYY" returnvariable="VFFecha2">
		<cfset filtro=filtro &  "and " &  #VFFecha1#  & " = '" & #form.IfechaGen#&"'">
	</cfif>
	<cfif isdefined('form.IfechaFin') and len(trim(form.IfechaFin)) GT 0>
		<cf_dbfunction name="date_format" args="r.FFECrecursivo,DD/MM/YYYY" returnvariable="VFFecha1">
		<cf_dbfunction name="date_format" args="#form.IfechaFin#,DD/MM/YYYY" returnvariable="VFFecha2">
		<cfset filtro=filtro &  "and " &  #VFFecha1#  & " = '" & #form.IfechaFin#&"'">
	</cfif>
	<!--- Fin Filtros para consulta--->
	
<cfset modo ="Modificar,Eliminar">
    <cfquery name="rsAsientosRecursivos" datasource="#session.dsn#">
        select r.IDcontable, h.Cconcepto, r.FFECrecursivo, h.Edescripcion, h.ECfechacreacion, Eperiodo, Emes
        from AsientosRecursivos r
            inner join HEContables h
            on h.IDcontable = r.IDcontable
        where r.Ecodigo = #session.Ecodigo# #PreserveSingleQuotes(filtro)#
    </cfquery>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cf_templateheader title="Documentos Contables Recurrentes">
			<cf_templatecss>
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Asientos Recurrentes">
		<table width="100%" cellpadding="2" cellspacing="0" >
			<tr>
				<td valign="top" align="left" width="550">
				<form name="formFiltro" action="DocumentosContablesRecurrentes.cfm" method="post">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
								<tr> 
									<td> Descripci&oacute;n : </td>
									<td> Fecha de Generacion :</td>
									<td> Fecha Final : </td>
									<td width="5%" colspan="2" rowspan="2"><input type="submit" class="btnFiltrar" value="filtrar" /> </td>
								</tr>
								<tr>
									<td>
										<input type="text" name="Fdescripcion" 
											value="<cfif isdefined('form.Fdescripcion') and trim(form.Fdescripcion) GT 0><cfoutput>#form.Fdescripcion#</cfoutput></cfif>"/>  
									</td>
									<td>
											<cfif isdefined('form.IfechaGen') and trim(form.IfechaGen) GT 0>
												 <cf_sifcalendario form="formFiltro" name="IfechaGen" value="#form.IfechaGen#">
											 <cfelse>
												 <cf_sifcalendario form="formFiltro" name="IfechaGen" value="">
											  </cfif>   
									</td>
									<td>
											<cfif isdefined('form.IfechaFin') and trim(form.IfechaFin) GT 0>
												 <cf_sifcalendario form="formFiltro" name="IfechaFin" value="#form.IfechaFin#">
											 <cfelse>
												 <cf_sifcalendario form="formFiltro" name="IfechaFin" value="">
											  </cfif>   
									</td>
								</tr>
				</table>	
				</form>			
                <cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
                    <cfinvokeargument name="query" 			value="#rsAsientosRecursivos#"/>
                    <cfinvokeargument name="desplegar" 		value=" Edescripcion, ECfechacreacion, FFECrecursivo"/>
                    <cfinvokeargument name="etiquetas" 		value=" Descripci&oacute;n, Fecha Gen, Fecha Fin"/>
                    <cfinvokeargument name="formatos" 		value=" S, D, D"/>
                    <cfinvokeargument name="align" 			value="left, left, left"/>
                    <cfinvokeargument name="ajustar" 		value="N"/>
                    <cfinvokeargument name="Incluyeform" 	value="true">
                    <cfinvokeargument name="formname" 		value="form"/>
                    <cfinvokeargument name="keys" 			value="IDcontable">
                    <cfinvokeargument name="irA" 			value="DocumentosContablesRecurrentes.cfm"/>
                    <cfinvokeargument name="navegacion" 	value="">
                    <cfinvokeargument name="MaxRows" 		value="15">
                </cfinvoke>
				</td>
                <td valign="top">
					
                    <form name="form1" method="post" action="SQLContablesRecurrentes.cfm" onsubmit="return fnChequear()">
						<cfif isdefined ("form.Edescripcion")>
                            <input type="hidden" name="IDcontable" value="<cfoutput>#form.IDcontable#</cfoutput>" />
                            <cfset LvarFecha = createdate(form.Eperiodo, form.Emes, 01)> 
                        </cfif>
                        <table>
                         	<tr>
                            	<td> Descripci&oacute;n : </td>
                                <td><cfif isdefined ("form.Edescripcion")><cfoutput>#form.Edescripcion#</cfoutput> <cfelse> -------</cfif></td>
                            </tr>
                                <td> Fecha de Generacion :</td>
                                <td><cfif isdefined ("form.Edescripcion")><cfoutput>#LSDateFormat(form.ECfechacreacion)#</cfoutput><cfelse> -------</cfif></td>
                            </tr>
                            <tr>
                            	<td> Fecha Final : </td>
                                <td> 
									<cfif isdefined ("form.FFECRECURSIVO") and len(trim(form.FFECRECURSIVO))>
                                        <cf_sifcalendario name="N_FFECRECURSIVO" value="#LSDateFormat(form.FFECRECURSIVO,'dd/mm/yyyy')#">
                                    <cfelse>
                                        <cf_sifcalendario  name="N_FFECRECURSIVO" value="" >
                                    </cfif>
                                </td>
                            </tr>                      	   
                          </table>
                          <cfif isdefined ("form.Edescripcion")>
                              <div style="text-align:center">
                                    <cf_botones modo="#modo#" values="#modo#">
                              </div>
                          </cfif>
                      </form>
				</td>	
			</tr>
		</table>
        <cf_web_portlet_end>	
<cf_templatefooter>
<script>
	<cfif isdefined ("form.Edescripcion")>
		function fnChequear(){
			if(form1.botonSel.value =="btnCAMBIO"){
				fechaLimite = "<cfoutput>#LSDateFormat(LvarFecha,'dd/mm/yyyy')#</cfoutput>";
				fechaNueva = document.getElementById("N_FFECRECURSIVO").value;
				if(fechaNueva==""){
					alert("Debe seleccionar una Fecha")
					return false;
				}
				else if (fnToFecha(fechaNueva)<fnToFecha(fechaLimite)){
						document.getElementById("N_FFECRECURSIVO").value="";
						alert("No puede seleccionar una fecha menor al periodo actual,  seleccione una nueva fecha.")
						return false;
					}
					else{
						return true;
					}
			}
			else  {return true;}
		}
		function fnToFecha(fecha){
			fecha = fecha.split("/");
			return new Date(parseInt(fecha[2], 10), parseInt(fecha[1], 10)-1, parseInt(fecha[0], 10));
		}
	</cfif>
</script>
