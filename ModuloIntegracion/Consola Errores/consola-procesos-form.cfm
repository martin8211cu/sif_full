<cf_templateheader title="Bitacora de Procesos">  
<cf_web_portlet_start titulo="Registros con Error">

<cf_navegacion name="fltIdDesde" 		navegacion="" session default="">
<cf_navegacion name="fltIdHasta" 		navegacion="" session default="">
<cf_navegacion name="fltUsuario" 		navegacion="" session default="">
<cf_navegacion name="fltInterfaz" 		navegacion="" session default="-1">
<cf_navegacion name="ver"		 		navegacion="" session default="">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<!--- Cambio ABG 8/01/2010 para ver solo los errores de la empresa en la que se ha logueado --->
<cfquery name="rsEmpresaError" datasource="sifinterfaces">
    select EQUcodigoOrigen
    from SIFLD_Equivalencia
    where CATcodigo like 'CADENA'
    and EQUidSIF like convert(varchar,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>

<cfquery name="RsProcesos" datasource="sifinterfaces">
select distinct Interfaz 
from SIFLD_Errores 
where 1=1
<cfif rsEmpresaError.recordcount GT 0>
	and Ecodigo in(#ValueList(rsEmpresaError.EQUcodigoOrigen)#)
    or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfif>
order by Interfaz
</cfquery>

<cfquery name="RsUsuarios" datasource="sifinterfaces">
select distinct Usuario
from SIFLD_Errores 
where Usuario is not null
<cfif rsEmpresaError.recordcount GT 0>
	and Ecodigo in(#ValueList(rsEmpresaError.EQUcodigoOrigen)#)
    or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfif>
order by Usuario
</cfquery>

<cfif not isdefined("form.fltInterfaz") and not isdefined("url.fltInterfaz")>
	<cfset form.fltInterfaz = -1>
</cfif>
<cfif not isdefined("form.fltUsuario") and not isdefined("url.fltUsuario")>
	<cfset form.fltUsuario = -1>
</cfif>

<!--- ****************************************************************  --->
<cfset LvarNavegacion = "">

<cfparam name="Registros" default="20">
<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
	<cfset form.ver = url.ver >
</cfif>
<cfif isdefined("form.ver") and len(trim(form.ver)) and form.ver GT 0>
	<cfset Registros = form.Ver>
</cfif>
<cfif isdefined("form.ver") and len(trim(form.ver)) and form.ver GT 0>
	<cfset LvarNavegacion = LvarNavegacion & "&ver=#Form.ver#">
</cfif>

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
<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js">//</script>
<cfoutput> 
<form method="post" action = "consola-procesos-form.cfm" name="frmFiltro" style="margin:0 0 0 0">
    <table class="AreaFiltro" width="100%">
        <tr>
            <td width="55">Interfaz: </td>
            <td width="200">
                <select name="fltInterfaz"> 
                <option value="-1" selected="selected">(Todas las interfaces...)</option>
                <cfloop query="RsProcesos">
                    <option value="#RsProcesos.Interfaz#" <cfif isdefined("form.fltInterfaz") and trim(form.fltInterfaz) EQ trim(RsProcesos.Interfaz)>selected</cfif>>#RsProcesos.Interfaz#</option>
                </cfloop>
                </select>
            </td>
            <td width="40">IDs:</td> 
            <td width="100">	<input type="text" name="fltIDdesde" size="12" value="#form.fltIdDesde#" /></td>
            <td width="30">al:</td>        
            <td width="100"><input type="text" name="fltIDhasta" size="12" value="#form.fltIdHasta#" /> </td>
            <td width="100" align="right">Usuario:</td>
            <td width="200">
            <select name="fltUsuario"> 
            <option value="-1" selected="selected">(Todos...)</option>
            <cfloop query="RsUsuarios">
                <option value="#RsUsuarios.Usuario#" <cfif isdefined("form.fltUsuario") and trim(form.fltUsuario) EQ trim(RsUsuarios.Usuario)>selected="selected"</cfif>>#RsUsuarios.Usuario#</option>
            </cfloop>
            </select>
            </td>
        </tr>
        
        <tr>
        	<td align="left" colspan="2">
            	<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
                <label for="chkTodos">Seleccionar Todos</label>
            </td>
            <td>Ver:</td>
            <td colspan="3"><input name="Ver" type="text" id="Ver" <cfif isdefined('form.Ver')> value="#form.Ver#"</cfif> maxlength="4"
            style="text-align: right" size="5" tabindex="3" onBlur="javascript:fm(this,0); FuncLimite();" onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
            </td>
            <td align="right">
            	Refrescar&nbsp;
            	<input type="checkbox" id="chkRefrescar" name="chkRefrescar" 
					<cfif isdefined("Form.chkRefrescar") and Form.chkRefrescar EQ 1>
                    	checked</cfif> 
	                    onclick="if (this.checked) { document.getElementById('Filtrar').click(); }" value="1">
            </td>
            <td><input name="submit" type="submit" id="Filtrar" value="Filtrar" /></td>
        </tr>
 	    <tr>
    		<td colspan="8">
                <cfquery name="rsLista" datasource="sifinterfaces">
                      select                 
                          '<img src=''/cfmx/sif/imagenes/findsmall.gif'' style=''cursor:pointer;'' >' as VER,          
                          ID_Error, Interfaz, ID_Documento, MsgError,Tabla, Usuario
                      from SIFLD_Errores
                      where 1=1
                      <cfif form.fltUsuario neq -1>
                          and Usuario = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltUsuario)#">
                      </cfif>
                      <cfif form.fltInterfaz neq -1>
                          and Interfaz = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltInterfaz)#">
                      </cfif>
                      <cfif	Len(Trim(Form.fltIdDesde)) and isnumeric(Form.fltIdDesde) and form.fltIDdesde neq "" and Len(Trim(Form.fltIdHasta)) and isnumeric(Form.fltIdHasta) and form.fltIdHasta neq "">
                          and ID_Error between 
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.fltIDdesde)#">
                            and
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(form.fltIdHasta)#">
                       </cfif>
                       <cfif rsEmpresaError.recordcount GT 0>
                          and (Ecodigo in(#ValueList(rsEmpresaError.EQUcodigoOrigen)#)
                          or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
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
			<cfinvokeargument name="cortes" value="Interfaz"/>
			<cfinvokeargument name="desplegar" value="Ver,ID_Error,ID_Documento,Interfaz,MsgError,Usuario"/>
			<cfinvokeargument name="etiquetas" value="Ver,ID Error,Documento,Interfaz,Error,Usuario"/>
			<cfinvokeargument name="formatos" value="S,I,I,S,S,S"/>
			<cfinvokeargument name="ajustar" value="N,N,N,N,S,N"/>
			<cfinvokeargument name="align" value="center,center, center, center, left,left"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="irA" value="consola-procesos-registro.cfm"/>   
            <cfinvokeargument name="MaxRows" value="#Registros#"/>
			<cfinvokeargument name="showLink" value="true"/>
			<cfinvokeargument name="keys" value="ID_Error"/>
			<cfinvokeargument name="botones" value="Reprocesar,Eliminar"/>
            <cfinvokeargument name="navegacion" value="#LvarNavegacion#"/>
		</cfinvoke>

</cfoutput> 

<!--- <cfabort showerror="aqui"> --->

<script type="text/javascript">

setTimeout("if (document.getElementById('chkRefrescar').checked) document.getElementById('Filtrar').click()",15*1000);	

function algunoMarcadoR(){
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

function algunoMarcadoE(){
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
			return (confirm("¿Eliminar Registros seleccionados?"));
		} else {
			alert('Debe seleccionar al menos un documento antes de Eliminar');
			return false;
		}
	}
	
function funcReprocesar() {
		if (algunoMarcadoR())
			document.lista.action = "consola-procesos-reproceso.cfm";
		else
			return false;
	}
	
function funcEliminar() {
		if (algunoMarcadoE())
			document.lista.action = "consola-procesos-eliminar.cfm";
		else
			return false;
	}
function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.lista.chk.length; counter++)
			{
				if ((!document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.lista.chk.length; counter++)
			{
				if ((document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = false;
			}
		};
	}
</script>

<cf_web_portlet_end>
<cf_templatefooter> 