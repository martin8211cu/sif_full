<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Seguridad" Default= "Seguridad" XmlFile="formPerfilesModulos.xml" returnvariable="LB_Seguridad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_OpcióndeSeguridad" Default= "Opción de Seguridad" XmlFile="formPerfilesModulos.xml" returnvariable="LB_OpcióndeSeguridad"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DeseaEliminar" Default= "¿Está seguro(a) de que desea eliminar el registro?" XmlFile="formPerfilesModulos.xml" returnvariable="LB_DeseaEliminar"/>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cf_dbfunction name="to_char"	args="c.ADSPPid"            returnvariable="ADSPPid">
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
<cfif isdefined("url.ADSPid") and url.modo EQ "CAMBIODET">
	<cfset modo="CAMBIODET">
<cfelseif isdefined("url.ADSPid") and url.modo EQ "CAMBIO">
	<cfset modo="CAMBIO">
</cfif>
<cfif modo NEQ "ALTA">
	<cfquery name="rsCtasMayor" datasource="#Session.DSN#">
		select ADSPid, ADSPcodigo, ADSPdescripcion
		  from ADSEPerfil
		 where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   and ADSPid = <cfqueryparam value="#Form.ADSPid#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfquery name="rsPerfilProceso" datasource="#Session.DSN#">
		select * from ADSPerfilProceso a
        where ADSPPid not in(
                select c.ADSPPid from ADSEPerfil a
                    inner join ADSDPerfil b
                        on a.ADSPid = b.ADSPid
                    inner join ADSPerfilProceso c
                        on b.ADSPPid = c.ADSPPid
                where a.ADSPid = #form.ADSPid#)
				order by SMcodigo
	</cfquery>
	<cfquery name="rsPerfilesSeguridad" datasource="#Session.DSN#">
           select * from ADSEPerfil a
            	inner join ADSDPerfil b
                	on a.ADSPid = b.ADSPid
                    and a.Ecodigo = b.Ecodigo
            	inner join ADSPerfilProceso c
                	on b.ADSPPid = c.ADSPPid
           where a.ADSPid = #form.ADSPid#
		  	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfquery>
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Btn_Idioma = t.Translate('Btn_Idioma','Idioma')>
<form method="post" name="form1" action="SQLPerfiles.cfm" onSubmit="javascript: return valida(); ">
<cfoutput>
	<cfif isdefined("Form.PageNum10") and Len(Trim(Form.PageNum10))>
		<input type="hidden" name="PageNum_lista10" value="#Form.PageNum10#" />
	<cfelseif isdefined("Form.PageNum_lista10") and Len(Trim(Form.PageNum_lista10))>
		<input type="hidden" name="PageNum_lista10" value="#Form.PageNum_lista10#" />
	</cfif>
	<cfif isdefined("Form.ADSPcodigo") and Len(Trim(Form.ADSPcodigo))>
		<input type="hidden" name="ADSPcodigo" value="#Form.ADSPcodigo#" />
	<cfelseif isdefined("Form.ADSPcodigoF") and Len(Trim(Form.ADSPcodigoF))>
		<input type="hidden" name="ADSPcodigoF" value="#Form.ADSPcodigoF#" />
	</cfif>
	<cfif isdefined("Form.ADSPdescripcion") and Len(Trim(Form.ADSPdescripcion))>
		<input type="hidden" name="ADSPdescripcion" value="#Form.ADSPdescripcion#" />
	<cfelseif isdefined("Form.ADSPdescripcionF") and Len(Trim(Form.ADSPdescripcionF))>
		<input type="hidden" name="ADSPdescripcionF" value="#Form.ADSPdescripcionF#" />
	</cfif>
	<cfif isdefined("Form.ADSPid") and Len(Trim(Form.ADSPid))>
		<input type="hidden" name="ADSPid" value="#Form.ADSPid#" />
	</cfif>
</cfoutput>
<cfif modo EQ "ALTA">
	<cfquery name="rsPerfilProceso" datasource="#Session.DSN#">
        select * from ADSPerfilProceso
        order by SMcodigo
        </cfquery>
</cfif>
	<fieldset>
		<legend>
			<strong>
				<cfoutput>
					#LB_Seguridad#
				</cfoutput>
			</strong>
		</legend>
		<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<!--- ********************************************************************************* --->
		<tr>
			<td align="left">
				<strong>
					<cfoutput>
						#LB_OpcióndeSeguridad#
					</cfoutput>
					:&nbsp;
				</strong>
			</td>
		</tr>
		<tr>
			<td>
				<select name="PerfilProceso">
					<option value="">
						-- Seleccionar Opción de Seguridad --
					</option>
					<cfoutput query="rsPerfilProceso">
						<cfif modo EQ "ALTA">
							<option value="#rsPerfilProceso.ADSPPid#">
								#rsPerfilProceso.SPdescripcion#
							</option>
						<cfelse>
							<option value="#rsPerfilProceso.ADSPPid#"
							<cfif rsPerfilesSeguridad.ADSPPid EQ rsPerfilProceso.ADSPPid>
								selected>
							</cfif>
							<b>
								#rsPerfilProceso.SMdescripcion#-#rsPerfilProceso.SPdescripcion#
							</b>
							</option>
						</cfif>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td>
				<cf_botones value="AltaD" name="AltaD" exclude="Limpiar">
			</td>
		</tr>
		<cfif MODO NEQ "ALTA">
			<tr>
				<td>
		                   <cfquery name="rsPerfilProceso" datasource="#Session.DSN#">
		                    select '<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("#LB_DeseaEliminar#")) return false; location.href=
		                    "SQLPerfiles.cfm?BorraD='+'1'+'&ADSPid=#form.ADSPid#'+'&ADSPDid=' #_Cat# <cf_dbfunction name="to_Char" args="ADSPDid">
								#_Cat# '";''>' as eli,* from ADSEPerfil a
		                       inner join ADSDPerfil b
		                        on a.ADSPid = b.ADSPid
		                       inner join ADSPerfilProceso c
		                        on  b.ADSPPid = c.ADSPPid
		                        where a.Ecodigo = b.Ecodigo
		                        and a.ADSPid = #form.ADSPid#
		                        order by ADSPcodigo
		                    </cfquery>


		            		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
									query="#rsPerfilProceso#"
									desplegar="eli,SMdescripcion, SPdescripcion"
									etiquetas=" ,Modulo, Proceso"
									formatos="S,S,S"
									ajustar="N,S,S"
									align="left,left,left"
									maxRows="15"
									showLink="no"
									incluyeForm="no"
									showEmptyListMsg="yes"
									keys="ADSPid,ADSPPid"
								/>
				</td>
		    </tr>
		</cfif>
			<!--- ********************************************************************************* --->
		</table>
	</fieldset>
</form>