<cfif isdefined("url.F_LGnumero") and len(trim(url.F_LGnumero))>
	<cfset arr = ListToArray(url.F_LGnumero)>
</cfif>
<cfquery name="rsLogines" datasource="#session.DSN#">
	select distinct a.CTid,a.CUECUE,c.LGnumero,c.LGlogin,a.CTtipoUso
	from ISBcuenta a
		inner join ISBproducto b
			on b.CTid = a.CTid
		inner join ISBlogin c
			on c.Contratoid = b.Contratoid
			and c.Habilitado=1
		inner join ISBserviciosLogin d
			on d.LGnumero = c.LGnumero
			and d.TScodigo = 'ACCS'
	where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente#">
	and a.Habilitado=1	
</cfquery>
<cfoutput>
	<form method="get" name="form1" action="gestion.cfm?traf=trafico" style="margin:0">
		<cfinclude template="gestion-hiddens.cfm">
		<table  width="100%"cellpadding="0" cellspacing="0" border="0">		
			<tr><td class="tituloAlterno">
				<table  width="100%"cellpadding="2" cellspacing="0" border="0">
					<tr>
						<td><label><cf_traducir key="login">Login</cf_traducir></label>
							<cfset corte="">
							<select name="F_LGnumero" tabindex="1">
								<option value="">---Todas---</option>
								<cfloop query="rsLogines">
									<cfif corte NEQ rsLogines.CTid>
										<cfset corte = rsLogines.CTid>
										<option 
										value="#corte#" 
										<cfif isdefined("arr") and ArrayLen(arr) EQ 1 and arr[1] EQ corte>selected</cfif>>
										<cfif ExisteCuenta and rsLogines.CUECUE GT 0>#rsLogines.CUECUE#<cfelseif rsLogines.CTtipoUso EQ 'U'>&lt;Por Asignar&gt;<cfelseif rsLogines.CTtipoUso EQ 'A'>(Acceso) &lt;Por Asignar&gt;<cfelseif rsLogines.CTtipoUso EQ 'F'>(Facturaci&oacute;n) &lt;Por Asignar&gt;</cfif>
										</option>
									</cfif>
									<option value="#rsLogines.LGnumero#,#corte#"
										<cfif isdefined("arr") and ArrayLen(arr) EQ 2 and arr[1] EQ rsLogines.LGnumero and arr[2] EQ corte>selected</cfif>>
										&nbsp;&nbsp;&nbsp;&nbsp;-#rsLogines.LGlogin#
									</option>
								</cfloop>
							</select>
					</td></tr>
				</table>
		</td></tr>
		
		<tr><td>
			<table  width="100%"cellpadding="0" cellspacing="0" border="0">		
				<tr class="tituloAlterno">
					<td align="left">Fecha Desde</td>
					<td align="left">Fecha Hasta</td>
					<td align="left">Login</td>
					<td align="left">Tel&eacute;fono</td>
					<td align="left">Direcci&oacute;n IP</td>
					<td>&nbsp;</td>
				</tr>
				<tr  class="tituloAlterno">
					<cfif isdefined("url.fdesde") and len(trim(url.fdesde))>
						<cfset fdesde=url.fdesde>
					<cfelse>
						<cfset fdesde=LSDateFormat(now(),'dd/mm/yyyy')>
					</cfif>	
					<td><cf_sifcalendario form="form1" name="fdesde" value="#fdesde#"></td>
					
					<cfif isdefined("url.fhasta") and len(trim(url.fhasta))>
						<cfset fhasta=url.fhasta>
					<cfelse>
						<cfset fhasta=LSDateFormat(now(),'dd/mm/yyyy')>
					</cfif>
					<td><cf_sifcalendario form="form1" name="fhasta" value="#fhasta#"></td>
					
					<td><input name="fLGlogin" size="15" type="text" value="<cfif isdefined("url.fLGlogin")>#url.fLGlogin#</cfif>"/></td>
					<td><input name="fEVtelefono" size="15" type="text" value="<cfif isdefined("url.fEVtelefono")>#url.fEVtelefono#</cfif>"/></td>
					<td><input name="fipaddr" size="15" type="text" value="<cfif isdefined("url.fipaddr")>#url.fipaddr#</cfif>"/></td>
				<td align="right"><cf_botones names="Consultar" values="Consultar" tabindex="1"></td>
				</tr>
			</table>
		</td></tr>
		</table>
	</form>
</cfoutput>