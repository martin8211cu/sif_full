
<cfif isdefined("Form.LVid")>
	<cfset Form.LVid2 = Form.LVid>
</cfif>
<cfif isdefined("Form.Aid2")>
	<cfset Form.id_tipo = Form.Aid2>
</cfif>

<!--- TOMA LAS VARIABLES REQUERIDAS DE LA URL CUANDO VIENE DE HACER CLIC EN EL BOTON FILTRAR --->
<cfif isdefined("Url.id_tipo") and len(trim(Url.id_tipo))>
	<cfif not isdefined("Form.id_tipo")>
		<cfset Form.id_tipo = Url.id_tipo>
	<cfelseif isdefined("Form.id_tipo") and len(trim(Form.id_tipo)) eq 0>
		<cfset Form.id_tipo = Url.id_tipo>
	</cfif>	
</cfif>
<cfif isdefined("Url.LVid") and len(trim(Url.LVid))>
	<cfif not isdefined("Form.LVid")>
		<cfset Form.LVid = Url.LVid>
	<cfelseif isdefined("Form.LVid") and len(trim(Form.LVid)) eq 0>
		<cfset Form.LVid = Url.LVid>
	</cfif>	
</cfif>

<cfif isdefined("Url.nombre") and len(trim(Url.nombre))>
	<cfif not isdefined("Form.nombre")>
		<cfset Form.nombre = Url.nombre>
	<cfelseif isdefined("Form.nombre") and len(trim(Form.nombre)) eq 0>
		<cfset Form.nombre = Url.nombre>
	</cfif>
</cfif>

<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DE LA PANTALLA DE MANTENIMIENTO O DEL BORRADO DEL SQL DE LA PANTALLA DE MANTENIMIENTO--->
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>	
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->				
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
	<cfset form.MTcodigo = 0>
</cfif>					
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<!--- VARIABLES DE FILTROS PARA CUANDO VIENE DE LA PANTALLA O DE LA NAVEGACIÓN --->
<cfif isdefined("url.Filtro_LVnombre2") and len(trim(url.Filtro_LVnombre2))>
	<cfset form.Filtro_LVnombre2 = url.Filtro_LVnombre2>
</cfif>
<cfif isdefined("url.Filtro_Habilit") and len(trim(url.Filtro_Habilit))>
	<cfset form.Filtro_Habilit = url.Filtro_Habilit>
</cfif>
<cfparam name="form.Pagina" default="1">					
<cfparam name="form.Filtro_LVnombre2" default="">
<cfparam name="form.Filtro_Habilit" default="">
<cfif len(trim(form.Pagina)) eq 0>
	<!--- CUANDO LE DAN CLICK AL FILTRAR EXISTE EL CAMPO PAGINA EN EL FORM PERO ESTÁ VACÍO PORQQUE EL CAMPO SE LLENA CUAND LE DAN CLICK A LA LISTA Y NO LE DIERON CLIK --->
	<cfset form.Pagina = 1>
</cfif>

<!--- DEFINE EL MODO --->
<cfset modo="ALTA">
<cfif isdefined("Form.LVid") and len(trim(Form.LVid))>
	<cfset modo="CAMBIO">
</cfif>
	
<!--- CONSULTAS --->	
<cfif modo NEQ 'ALTA'>
	<!--- 1. Form --->	
	<cfquery datasource="#Session.DSN#" name="rsISBatributoValor">
		select b.Aid,  substring(LVnombre,1,35) as LVnombre, a.Habilitado 
		from ISBatributoValor a, ISBatributo b
		where  b.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and a.Aid = b.Aid 
			<cfif isdefined("Form.LVid") AND Form.LVid NEQ "" >
			  and a.LVid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.LVid#">
			</cfif>
			<cfif isdefined("Form.Aid2") AND Form.Aid2 NEQ "" >
			  and a.Aid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid2#">
			</cfif>
	</cfquery>
</cfif>

<!--- INTERFASE --->
<cfoutput>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="tituloAlterno">
	Atributo: #Form.nombre#</td>
  </tr>
	<cfif isdefined("url.Err")>
		<tr align="center"> 
		  	<td style="font-weight: bold"> 
				<font color="##990000">#url.Err#</font>
 			</td>
		</tr>   
	</cfif>		

	<tr>
		<td>
			<form name="form1" method="post" action="ISBatributoValor-apply.cfm" onsubmit="return validar(this);">
				<!--- CAMPOS OCULTOS DE LA PAGINA Y DE LOS FILTROS PARA SER ENVIADOS AL FORM Y AL SQL --->
				<input name="pagina" id="pagina" value="#Form.pagina#" type="hidden" />
				<input name="Filtro_LVnombre2" id="Filtro_LVnombre2" value="#Form.Filtro_LVnombre2#" type="hidden" />
				<input name="Filtro_Habilit" id="Filtro_Habilit" value="#Form.Filtro_Habilit#" type="hidden" />
				
				<!--- CAMPOS OCULTOS DE LAS LLAVES PARA SER ENVIADOS AL FORM Y AL SQL --->
				<input name="nombre" id="nombre" value="#Form.nombre#" type="hidden" />
				<cfif isdefined("Form.id_tipo")  >
					<input name="id_tipo2" id="id_tipo2" value="#Form.id_tipo#" type="hidden" />
				<cfelseif isdefined("Form.Aid2")>
					<input name="id_tipo2" id="id_tipo2" value="#Form.Aid2#" type="hidden" />
				</cfif>
				<cfif modo NEQ 'ALTA' and isdefined("Form.LVid")>
					<!--- <input type="hidden" name="HayISBatributoDocumento" value="<cfif #rsHayISBatributoDocumento.recordCount# GT 0>#rsHayISBatributoDocumento.recordCount#<cfelse>0</cfif>" /> --->
					<input type="hidden" name="HayISBatributoDocumento" value="0" />
				</cfif>
				<cfif modo NEQ 'ALTA' and isdefined("Form.LVid")>
					<input name="LVid2" id="LVid2" value="#Form.LVid#" type="hidden" />
				</cfif>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td colspan="2" class="subTitulo">
							<strong>
								<cfif modo EQ 'ALTA'>
									Agregar 
								<cfelse> 
									Modificar
								</cfif> 
								Valor 
							</strong>	
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>					
					<tr>
					  <td align="right"><label for="Nombre">Nombre:</label></td>
					  <td> <input name="LVnombre" type="text" id="LVnombre" tabindex="1" size="40" maxlength="80" onfocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'>#rsISBatributoValor.LVnombre#<cfelseif isdefined("url.Err")>#url.LVnombreErr#</cfif>" /></td>
					</tr>
					<tr> 
					  <td align="right"><label for="Habilitado">Habilitado:<label></td>
					  <td> <input name="Habilitado" type="checkbox" value="0" <cfif modo NEQ "ALTA" and rsISBatributoValor.Habilitado EQ 1> checked<cfelseif isdefined("url.Err")and url.HabilitadoErr eq 1 > checked</cfif> tabindex="1"></td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr> 
					  <td colspan="2" align="center"> 
						<cf_botones modo="#modo#" include=" Salir " nameEnc="Tipo" generoEnc="M" tabindex="1">
					  </td>
					</tr>
				</table>
			</cfoutput>
			</form>				
		</td>
	</tr>
  <tr>
    <td align="center">
		 <form name="lista" method="post" action="ISBatributoValor-apply.cfm">
			<cfoutput>		 
				<!--- CAMPOS OCULTOS DE LA PAGINA Y DE LOS FILTROS PARA SER ENVIADOS AL FORM Y AL SQL --->
				<input name="pagina" id="pagina" value="#Form.pagina#" type="hidden" />
				<input name="nombre" id="nombre" value="#Form.nombre#" type="hidden" />
				<cfif isdefined("Form.id_tipo")  >
					<input name="id_tipo" id="id_tipo" value="#Form.id_tipo#" type="hidden" />
				<cfelseif isdefined("Form.Aid2")>
					<input name="id_tipo2" id="id_tipo2" value="#Form.Aid2#" type="hidden" />
				</cfif>
				<cfif isdefined("Form.id_tipo") and not isdefined("Form.Aid2")>
					<input name="id_tipo2" id="id_tipo2" value="#Form.id_tipo#" type="hidden" />				
				</cfif>
				<cfif modo NEQ 'ALTA' and isdefined("Form.LVid")>
					<!--- <input type="hidden" name="HayISBatributoDocumento" value="<cfif #rsHayISBatributoDocumento.recordCount# GT 0>#rsHayISBatributoDocumento.recordCount#<cfelse>0</cfif>" /> --->
					<input type="hidden" name="HayISBatributoDocumento" value="0" />
				</cfif>
				<cfif modo NEQ 'ALTA' and isdefined("Form.LVid")>
					<input name="LVid2" id="LVid2" value="#Form.LVid#" type="hidden" />
				</cfif>
			
			<!---PARAMETROS QUE SE ENVIAN POR LA URL AL HACER CLIC EN FILTRAR --->
			<cfset params = "nombre="& Form.nombre>
			<cfif isdefined("Form.id_tipo") and len(trim(Form.id_tipo))>
				<cfset params = params & "&id_tipo="& Form.id_tipo>
			<cfelseif isdefined("Form.Aid2") and len(trim(Form.id_tipo))>
				<cfset params = params & "&Aid2="& Form.Aid2>
			</cfif>
			<cfif modo NEQ 'ALTA' and isdefined("Form.LVid") and len(trim(Form.LVid))>
				<!--- <cfif #rsHayISBatributoDocumento.recordCount# GT 0>
					<cfset params = params & "&HayISBatributoDocumento=" & rsHayISBatributoDocumento.recordCount>
				<cfelse>
					<cfset params = params & "&HayISBatributoDocumento=0">
				</cfif> --->
				<cfset params = params & "&HayISBatributoDocumento=0">
			</cfif>
			<cfif modo NEQ 'ALTA' and isdefined("Form.LVid") and len(trim(Form.LVid))>
				<cfset params = params & "&LVid=" & Form.LVid>
			</cfif>
			<!--- NAVEGACION --->
			<cfset nav = "">
			<cfset nav = nav & "pagina="&form.pagina & "&Filtro_LVnombre2="&form.Filtro_LVnombre2& "&Filtro_Habilit="&form.Filtro_Habilit>
			<cfif isdefined("form.id_tipo") and len(trim(form.id_tipo))>
				<cfset nav = nav & "&id_tipo="&form.id_tipo>
			</cfif>
			<cfif isdefined("form.nombre") and len(trim(form.nombre))>
				<cfset nav = nav & "&nombre="&form.nombre>
			</cfif>
			<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO HABILITADO--->
			<cfquery datasource="#session.dsn#" name="rsHabilitado">
				select '' as value, '-- todos --' as description, '0' as ord
				union
				select '0' as value, 'Inhabilitado' as description, '1' as ord
				union
				select '1' as value, 'Habilitado' as description, '2' as ord
				order by 3,2
			</cfquery>			
			
			<cfset imgCheck = "<img src=''/cfmx/saci/images/w-check.gif'' border=''0'' title=''Habilitada''>">
			<!--- LISTA --->
			<cfinvoke 
				 component="sif.Componentes.pListas" 
				 method="pLista">
					  <cfinvokeargument name="tabla" value="ISBatributoValor a,  ISBatributo b"/>
					  <cfinvokeargument name="columnas" value=" 
					  	convert(varchar,a.LVid) as LVid
						, convert(varchar,a.Aid) as Aid2
						, substring(a.LVnombre,1,35) as LVnombre2
						, case a.Habilitado 
							when 0 then ''
							when 1 then '#imgCheck#'							
						 end Habilit										
						, a.Habilitado								
						"/>
					  <cfinvokeargument name="desplegar" value="LVnombre2, Habilit"/>
					  <cfinvokeargument name="etiquetas" value="Nombre, Habilitado"/>
					  <cfinvokeargument name="filtro" value=" b.Ecodigo = #Session.Ecodigo# and a.Aid = #form.id_tipo# and a.Aid = b.Aid order by a.LVnombre"/>
					  <cfinvokeargument name="align" value="left,left"/>
					  <cfinvokeargument name="ajustar" value="N"/>
					  <cfinvokeargument name="maxRows" value="17"/>
					  <cfinvokeargument name="irA" value="ISBatributoValor.cfm"/>
					  <cfinvokeargument name="incluyeForm" value="false"/>
					  <cfinvokeargument name="formName" value="lista"/>
					  <cfinvokeargument name="conexion" value="#session.DSN#"/>
					  <cfinvokeargument name="keys" value="LVid"/>
					  <cfinvokeargument name="formatos" value="S,U"/>
					  <cfinvokeargument name="mostrar_filtro" value="true"/>
					  <cfinvokeargument name="filtrar_automatico" value="true"/>
					  <cfinvokeargument name="filtrar_por" value="a.LVnombre,a.Habilitado"/>
					  <cfinvokeargument name="navegacion" value="#nav#"/>
					  <cfinvokeargument name="rsHabilit" value="#rsHabilitado#"/>
					  <cfinvokeargument name="showEmptyListMsg" value="true">
					  <cfinvokeargument name="EmptyListMsg" value="--- No existen valores ---">
			</cfinvoke>
			</cfoutput>
		</form> 
		<script language="javascript" type="text/javascript">
			function funcFiltrar(){
				document.lista.action = "ISBatributoValor-apply.cfm?Filtrar=1#params#";
				return true;
			}
		</script>	
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr align="center"> 
      <td colspan="6" class="" align="center"> 
	  	
	  </td>
    </tr>
	<tr> 
      <td width="50%" valign="top"> 
		 	<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td>

				</td></tr>
			</table>
	  </td>
      <td width="50%" valign="top"> 

	  </td>
    </tr>
  </table>

	<script language="javascript" type="text/javascript">
		function funcSalir() {
			window.close();
			return false;
		}
		function validar(formulario) {
			if(document.form1.botonSel.value != "Nuevo"){
				var error_input;
				var error_msg = '';
				if (document.form1.LVnombre.value =="") {
					error_input = document.form1.LVnombre;
					error_msg += "\n - Debe digitar el nombre del nuevo valor.";
				}
				if (error_msg != '') {
					alert("Por favor revise los siguiente datos:"+error_msg);
					if (error_input && error_input.focus) error_input.focus();
					return false;
				}else return true;
			}
		}
	</script>
</body>
</html>
