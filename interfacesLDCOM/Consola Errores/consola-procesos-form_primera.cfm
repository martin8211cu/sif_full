<cf_templateheader title="Bitacora de Procesos">  
<cf_web_portlet_start titulo="Registros con Error">

<cf_navegacion name="fltIdDesde" 		navegacion="" session default="">
<cf_navegacion name="fltIdHasta" 		navegacion="" session default="">
<cf_navegacion name="fltInterfaz" 		navegacion="" session default="-1">

<cfquery name="RsProcesos" datasource="sifinterfaces">
select distinct Proceso from LDSIF_Errores order by Proceso
</cfquery>

<cfif not isdefined("form.fltInterfaz") and not isdefined("url.fltInterfaz")>
	<cfset form.fltInterfaz = -1>
</cfif>

<!--- ****************************************************************  --->
<cfset LvarNavegacion = "">

<cfif Len(Trim(Form.fltIdDesde)) and isnumeric(Form.fltIdDesde)>
	<cfif Len(Trim(Form.fltIdHasta)) and isnumeric(Form.fltIdHasta)>
		<cfset LvarNavegacion = LvarNavegacion & "&fltIdDesde=#Form.fltIdDesde#">
    </cfif>
</cfif>

<cfif Len(Trim(Form.fltIdHasta)) and isnumeric(Form.fltIdHasta)>
	<cfset LvarNavegacion = LvarNavegacion & "&fltIdHasta=#Form.fltIdHasta#">
</cfif>

<cfif Form.fltInterfaz NEQ "-1">
	<cfset LvarNavegacion = LvarNavegacion & "&fltInterfaz=#Form.fltInterfaz#">
</cfif>

<cfif isdefined("Form.chkRefrescar") and Form.chkRefrescar EQ 1>
	<cfset LvarNavegacion = LvarNavegacion & "&chkRefrescar=1">
</cfif>

<cfif LvarNavegacion NEQ "">
	<cfset LvarNavegacion = mid(LvarNavegacion,2,Len(LvarNavegacion))>
</cfif>

<cfoutput>  
<form method="post" action = "consola-procesos-form_primera.cfm" name="frmFiltro" style="margin:0 0 0 0">
    <table>
        <tr>
            <td width="50">&nbsp;</td>
            <td width="49">Interfaz : </td>
            <td colspan="2">
                <select name="fltInterfaz" > 
                <option value="-1">(Todas las interfaces...)</option>
                <cfloop query="RsProcesos">
                    <option value="#RsProcesos.Proceso#">#RsProcesos.Proceso#</option>
                </cfloop>
                </select>
                <script type="text/javascript">
					document.getElementById('fltInterfaz').selectedIndex = document.getElementById('fltInterfaz').value
				</script>
             </td>
        </tr>
        
        <tr>
	    	<td></td>
    		<td>IDs:</td>
    		<td width="92">     
    			<input type="text" name="fltIDdesde" size="10" value="#form.fltIdDesde#" /></td>
    		<td width="206">   al     :          
    			<input type="text" name="fltIDhasta" size="10" value="#form.fltIdHasta#" />
		    <td width="159" align="right">Refrescar&nbsp;
            	<input type="checkbox" id="chkRefrescar" name="chkRefrescar" 
					<cfif isdefined("Form.chkRefrescar") and Form.chkRefrescar EQ 1>
                    	checked</cfif> 
	                    onclick="if (this.checked) { document.getElementById('Filtrar').click(); }" value="1">
                <input name="submit" type="submit" id="Filtrar" value="Filtrar" />
            </td>
		    <td width="0"></td><td width="0"></td><td width="0"></td><td width="0"></td><td width="0"></td><td width="0"></td><td width="0"></td><td width="0"></td>
    		<td width="76">&nbsp;</td>
		    <td width="76">
<!---
    			<input name="FltRep" type="submit" id="Reproceso" value="Reproceso" onclick="document.getElementById('fltValor').value=1;alert('Registro en Proceso de Correccion');document.getElementById('Filtrar').click();document.getElementById('fltValor').value=0;"/>   --->
    		</td>
    	</tr>
 	    <tr>
    		<td></td>
		    <td colspan="3">
                  <cfquery name="rsLista" datasource="sifinterfaces">
                      select                 
                          '<img src=''/cfmx/sif/imagenes/findsmall.gif'' style=''cursor:pointer;'' >' as VER,          
                          ID_Error, Proceso, ID_Documento, CATcodigo, Estado, Columna_Error, Valor_Error
                      from LDSIF_Errores
                      <cfif form.fltInterfaz neq -1 and form.fltIDdesde eq "" and form.fltIdHasta eq "">
                          where proceso = '#trim(form.fltInterfaz)#'
                      
                      <cfelseif	Len(Trim(Form.fltIdDesde)) and isnumeric(Form.fltIdDesde) and Len(Trim(Form.fltIdHasta)) and isnumeric(Form.fltIdHasta)>
							<cfif form.fltInterfaz eq -1 and form.fltIDdesde neq "" and form.fltIdHasta neq "">
                                  where ID_Error between '#trim(form.fltIDdesde)#' and '#trim(form.fltIdHasta)#'
                            </cfif>
                            
                            <cfif form.fltInterfaz neq -1 and form.fltIDdesde neq "" and form.fltIdHasta neq "">
                                  where proceso = '#trim(form.fltInterfaz)#'
                                  and ID_Error between '#trim(form.fltIDdesde)#' and '#trim(form.fltIdHasta)#'
                            </cfif>
                      </cfif>     
                      order by ID_Error
                  </cfquery>
			</td>
    	</tr>
    </table>
 </form>
 
	   <cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsLista#"/>
			<cfinvokeargument name="cortes" value="Proceso"/>
			<cfinvokeargument name="desplegar" value="Ver,Id_Error,ID_Documento,Proceso,CATcodigo,Estado,Columna_Error,Valor_Error"/>
			<cfinvokeargument name="etiquetas" value="Ver,ID&nbsp;&nbsp;,Documento,ProcesoInterfaz,Catalogo,Status&nbsp;,Campo Error,Valor Campo"/>
			<cfinvokeargument name="formatos" value="S,S,V,S,S,S,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,N,N,N,S,N"/>
			<cfinvokeargument name="align" value="center,center, center, center, left, center, center, center, center"/>
			<cfinvokeargument name="lineaAzul" value="Estado EQ 'Pendiente'"/>
			<cfinvokeargument name="lineaRoja" value="Estado EQ 'OK'"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="irA" value="consola-procesos-registro.cfm"/>   
            <cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="botones" value="Reprocesar"/>
            <cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
		</cfinvoke>

</cfoutput> 

<!--- <cfabort showerror="aqui"> --->

<script type="text/javascript">

setTimeout("if (document.getElementById('chkRefrescar').checked) document.getElementById('Filtrar').click()",15*1000);	

function algunoMarcado(){
		var aplica = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				aplica = document.lista.chk.checked;
			}else{
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("¿Reprocesar Registros seleccionados?"));
		} else {
			alert('Debe seleccionar al menos un documento antes de Reprocesar');
			return false;
		}
	}
function funcReprocesar() {
		if (algunoMarcado())
			document.lista.action = "consola-procesos-reproceso.cfm";
		else
			return false;
	}

</script>

<cf_web_portlet_end>
<cf_templatefooter> 