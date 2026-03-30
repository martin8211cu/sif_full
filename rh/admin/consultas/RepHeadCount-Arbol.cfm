<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_CentroFuncional"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfparam name="dependencia" default="on">
<cfif isdefined('url.dependencia') and not isdefined('form.dependencia')>
	<cfset form.dependencia = url.dependencia>
</cfif>
<cfif isdefined('form.CFid')>
<cfquery name="rsCfuncional" datasource="#session.DSN#">
	select CFid,CFcodigo,CFdescripcion 
	from CFuncional 
	where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
</cfquery>
</cfif>
<cfquery name="rsPrimero" datasource="#session.DSN#">
	select CFid as pk
	from CFuncional
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and CFnivel = 0
</cfquery>
<cfif not isdefined('form.primero') and not isdefined('url.primero') 
		and not isdefined('form.CFpk') and not isdefined('url.CFpk')>
	<cfset form.primero = rsPrimero.pk>
	<cfset form.CFpk = rsPrimero.pk>
</cfif>
<cfif not isdefined('form.CFpk') and isdefined('url.CFpk')>
	<cfset form.CFpk = url.CFpk>
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
			<td>
				<!--- Este Árbol pinta 1 item y todos sus ancestros, y todos los items de la raíz --->
				<!--- <cfparam name="form.CFpk" default="0" type="numeric"> --->
				<!--- busqueda recursiva de los ancestros del item... se espera que los ancestros sean cuando mucho unos 4...  si son mas de 10 hay que cambiar esta solución. --->
				<cfif isdefined("url.primero")and len(trim(url.primero)) NEQ 0>
					<cfset form.primero = url.primero>
				</cfif>
				
				<cfset litem = "0">
				<cfset ruta  = "0">
				<cfif isdefined("Form.CFpk")and len(trim(Form.CFpk))NEQ 0>
					<cfset litem = Form.CFpk>
					<cfset ruta =  Form.CFpk>
				<cfelseif isdefined("url.CFpk")and len(trim(url.CFpk))NEQ 0>
					<cfset litem = url.CFpk>
					<cfset ruta =  url.CFpk>
				</cfif>
				<cfif isdefined("Form.CFpk_papa")and len(trim(Form.CFpk_papa)) NEQ 0>
					<cfset form.primero = form.CFpk_papa>
					<cfset litem = Form.CFpk_papa>
					<cfset ruta =  Form.CFpk_papa>
				</cfif>
				
				<cfset n=0>
				<cfloop condition="litem neq 0 and n lt 50">
					<cfset n=n+1>
					<cfquery datasource="#session.dsn#" name="papa">
						select  ( case CFnivel when 0 then 0 else CFidresp end ) as ancestro
						from CFuncional
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#litem#">
					</cfquery>
				
					<cfset ruta = ruta & iif(len(trim(ruta)),DE(','),DE('')) & papa.ancestro>
					<cfset litem = papa.ancestro>
				</cfloop>
				<cfset ruta = ruta & iif(len(trim(ruta)),DE(','),DE('')) & "0">
				<br>
				<!--- ------------------------------------------------------------------------------- --->
				<cfset litem2 = "0">
				<cfset ruta2  = "0">
				<cfif isdefined("form.primero")>			<!--- trae todos los items por pintar del centro inicial--->
					<cfset litem2 = trim(form.primero)>
					<cfset ruta2  = trim(form.primero)>
				</cfif>
				
				<cfset n=0>
				<cfloop condition="litem2 neq 0 and n lt 50">
					<cfset n=n+1>
					<cfquery datasource="#session.dsn#" name="papa2"><!--- lista de padres/ruta--->
						select ( case CFnivel when 0 then 0 else CFidresp end ) as ancestro
						from CFuncional
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val(litem2)#">
					</cfquery>
					<cfset ruta2 = ruta2 & iif(len(trim(ruta2)),DE(','),DE('')) & papa2.ancestro>
					<cfset litem2 = papa2.ancestro>
				</cfloop>
				
				<cfset ruta2 = ruta2 & iif(len(trim(ruta2)),DE(','),DE('')) & "0">
				
				<!--- ------------------------------------------------------------------------------- --->
				
				<cfquery datasource="#session.dsn#" name="lista" maxrows="200"><!--- trae todos los items por pintar del centro actual--->
					select 	c.CFid as item, 
							{fn concat({fn concat(
							rtrim(c.CFcodigo) , ' - ' )},  c.CFdescripcion )} as name, 
							( case c.CFnivel when 0 then 0 else c.CFidresp end ) as ancestro, 
							(	select 
								count(*) from CFuncional h
								where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  	and ( case h.CFnivel when 0 then null else h.CFidresp end ) = c.CFid) as hijos
					from CFuncional c
					where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and (  ( case c.CFnivel when 0 then null else c.CFidresp end )  in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ruta#" list="yes">) 
					  		or ( case c.CFnivel when 0 then null else c.CFidresp end ) in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ruta2#" list="yes">))
					  and CFid != 0
					order by CFpath
				</cfquery>
				
				<cfset path=ruta>
				<cfset path2=ruta2>
				<cfif IsDefined('form.CFpk')>
					<cfset url.ARBOL_pos = form.CFpk>
				<cfelse>
					<cfset url.ARBOL_POS = ''>
				</cfif>
				
				<cfquery datasource="#session.dsn#" name="ARBOL">
					select 	c.CFid as pk, 
							c.CFcodigo as codigo, 
							c.CFdescripcion as descripcion, 
							c.CFnivel as nivel,  
						(select count(1) from CFuncional c2
							where ( case c2.CFnivel when 0 then 0 else c2.CFidresp end ) = c.CFid
							  and c2.Ecodigo = c.Ecodigo) AS  hijos
					from CFuncional c
					where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and ( ( case c.CFnivel when 0 then null else c.CFidresp end ) is null
					  	<cfif Len(path)>
							or ( case c.CFnivel when 0 then null else c.CFidresp end ) in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path#" list="yes">)
						</cfif>
						<cfif Len(path2)>
							or ( case c.CFnivel when 0 then null else c.CFidresp end ) in (<cfqueryparam cfsqltype="cf_sql_integer" value="#path2#" list="yes">)
						</cfif>
					  )
					order by c.CFpath
				</cfquery>
				
				<cfoutput>
				
					<style type="text/css">
					<!--- estos estilos se usan para reducir el tamaño del HTML del arbol --->
					.ar1 {background-color:##D4DBF2;cursor:pointer;}
					.ar2 {background-color:##ffffff;cursor:pointer;}
					</style>
					<script type="text/javascript" language="javascript">
					<!--
					<!--- Recibe conexion, form, name y desc --->
					function Asignar(id,name,desc) {
						
						if(document.miniform.dependencia.checked== true)
						{	
							<cfif isdefined("form.primero")>
								location.href='RepHeadCount.cfm?dependencia=1&primero=#form.primero#&CFpk=' + escape(id);
							<cfelse>
								location.href='RepHeadCount.cfm?dependencia=1&CFpk=' + escape(id);
							</cfif>
						}
						else
						{
							<cfif isdefined("form.primero")>
								location.href='RepHeadCount.cfm?primero=#form.primero# &CFpk=' + escape(id);
							<cfelse>
								location.href='RepHeadCount.cfm?CFpk=' + escape(id);
							</cfif>
						}	
					}
					<!--- estas funciones se usan para reducir el tamaño del HTML del arbol --->
					function eovr(row){<!--- event: MouseOver --->
						row.style.backgroundColor='##e4e8f3';
					}
					function eout(row){<!--- event: MouseOut --->
						row.style.backgroundColor='##ffffff';
					}
					function eclk(arbol_pos){<!--- event: Click --->
						if(document.miniform.dependencia.checked== true)
						{
							<cfif isdefined("form.primero")>
								location.href="RepHeadCount.cfm?dependencia=1&primero=#form.primero#&CFpk="+arbol_pos;
							<cfelse>
								location.href="RepHeadCount.cfm?dependencia=1&CFpk="+arbol_pos;
							</cfif>
						}
						else
						{
							<cfif isdefined("form.primero")>
								location.href="RepHeadCount.cfm?primero=#form.primero# &CFpk="+arbol_pos;
							<cfelse>
								location.href="RepHeadCount.cfm?CFpk="+arbol_pos;
							</cfif>
						}
					}
					//-->
					</script>
				
					<table cellpadding="1" cellspacing="0" border="0" width="100%">
					
					<form name="miniform" action="RepHeadCount.cfm" method="post" onsubmit="return validar(this);">
						<input name="CFpkR" type="hidden" value="<cfif isdefined('form.CFpk')>#form.CFpk#<cfelseif isdefined('url.CFpk')>#url.CFpk#</cfif>">
						<input name="CFpk" type="hidden" value="<cfif isdefined('form.CFpk')>#form.CFpk#<cfelseif isdefined('url.CFpk')>#url.CFpk#</cfif>">
						<input name="primeroR" type="hidden" value="#form.primero#">
						<input name="primero" type="hidden" value="#form.primero#">
						<!--- <input name="dependencia" type="hidden" value="on"> --->
						<input name="dependenciaR" type="hidden" value="<cfif isdefined('form.dependecia')>#form.dependencia#</cfif>">
					<tr>
						<td align="right"><strong><cf_translate key="LB_FechaDeCorte">Fecha de Corte</cf_translate>:</strong></td>
						<td><cf_sifcalendario value="#LSDateFormat(Now(),'dd/mm/yyyy')#" form="miniform"></td>
					</tr>
					<tr>
						<td nowrap="true" align="right"><strong>#LB_CentroFuncional#:</strong></td>
						<td>
							<cfif isdefined('form.CFid')>
								<cf_rhcfuncional  form="miniform" query="#rsCfuncional#" size="30">
							<cfelse>
								<cf_rhcfuncional  form="miniform" size="30">
							</cfif>
						</td>
					</tr>
 					<tr>
						<td nowrap="true" align="right"><input name="dependencia" type="checkbox" <cfif isdefined("form.dependencia")> checked  </cfif>/></td>
						<td><strong><cf_translate key="CHK_MostrarDependencias">Mostrar Dependencias</cf_translate></strong></td>
					</tr>
					<tr><td colspan="2"><cf_botones values="Filtrar"></td></tr>
					</form>
					<tr><td colspan="2">&nbsp;</td></tr>
					<cfset pasoCfpk=0>
					<cfset pasoPrimero=0>
					<cfloop query="ARBOL">
						<tr valign="middle"	
						<cfif ARBOL.pk is url.ARBOL_POS>
						
							class='ar1'
							onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#HTMLEditFormat(JSStringFormat(ARBOL.descripcion))#')"
						
						<cfelse>
						
							class='ar2' onMouseOver="eovr(this)"
							onMouseOut="eout(this)" <cfif ARBOL.hijos>onClick="eclk('#ARBOL.pk#')"<cfelse>onclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#HTMLEditFormat(JSStringFormat(ARBOL.descripcion))#')"</cfif>
						
						</cfif>
						
						ondblclick="Asignar(#ARBOL.pk#,'#JSStringFormat(Trim(ARBOL.codigo))#','#HTMLEditFormat(JSStringFormat(ARBOL.descripcion))#')">
							<td colspan="2" nowrap width="100%">
								#RepeatString('&nbsp;', ARBOL.nivel*2+2)#
								
								<cfif ARBOL.hijos and ListFind(path,ARBOL.pk)>
									<img src="/cfmx/rh/js/xtree/images/openfoldericon.png" width="16" height="16" border="0" align="absmiddle">
								<cfelseif ARBOL.hijos>
									<img src="/cfmx/rh/js/xtree/images/foldericon.png" width="16" height="16" border="0" align="absmiddle">
								<cfelse>
									<img src="/cfmx/rh/js/xtree/images/file.png" width="16" height="16" border="0" align="absmiddle">
								</cfif>
								
								#HTMLEditFormat(Trim(ARBOL.codigo))# - #HTMLEditFormat(Trim(ARBOL.descripcion))#
							</td>
						</tr>
					</cfloop>
					</table>
				</cfoutput>
			</td>
		</tr>
	</table>
	</cfoutput>
<script language="javascript">
	function validar(formulario){
		var mensaje = '<cfoutput>Se presentaron los siguientes errores</cfoutput>:\n';
		var error = false;
		if ( trim(formulario.CFid.value) == '' ){
				mensaje = mensaje + ' - <cfoutput>El campo Centro Funcional es requerido</cfoutput>\n' 
				formulario.CFid.style.backgroundColor = '#FFFFCC';
				error = true;
			}
		if (error){
			alert(mensaje);
			return false;
		}

		return true;
	
	}
	
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
</script>