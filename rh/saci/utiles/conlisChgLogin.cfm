<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Nuevo Login</title>
</head>

<body>
	<cfset solicitarDatos = true>
	<cfif isdefined("form.f")><cfparam name="url.f" default="#form.f#"></cfif>
	<cfif isdefined("form.sufijo")><cfparam name="url.sufijo" default="#form.sufijo#"></cfif>
	<cfif isdefined("form.Pquien")><cfparam name="url.Pquien" default="#form.Pquien#"></cfif>
	<cfif isdefined("form.LGnumero")><cfparam name="url.LGnumero" default="#form.LGnumero#"></cfif>

	<cfif isdefined("form.Enviar") and isdefined("form.logintext") and Len(Trim(form.logintext))
		  and isdefined("form.sufijo") and isdefined("form.Pquien") and Len(Trim(form.Pquien))>
		<!--- Chequear existencia del login --->
		<cfinvoke component="saci.comp.ISBlogin" method="Existe" returnvariable="ExisteLogin">
			<cfinvokeargument name="LGlogin" value="#form.logintext#">
			<cfif isdefined("form.LGnumero") and Len(Trim(form.LGnumero))>
				<cfinvokeargument name="LGnumero" value="#form.LGnumero#">
			</cfif>
		</cfinvoke>
		<cfif not ExisteLogin>
			<cfoutput>
				<script language="javascript" type="text/javascript">
					window.opener.AsignarLogin#form.sufijo#('#form.logintext#');
					window.close();
				</script>
			</cfoutput>
			<cfset solicitarDatos = false>
		</cfif>
	</cfif>

	<cfif solicitarDatos and isdefined("url.Pquien") and Len(Trim(url.Pquien)) and isdefined("url.LGnumero")>
		<cfquery name="rsDatos" datasource="#session.dsn#">
			select Pnombre, Papellido, Papellido2, PrazonSocial
			from ISBpersona
			where Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Pquien#">
		</cfquery>
		
		<!--- Se eliminan las tildes --->
		<cfset CNFormat = replacelist(rsDatos.Pnombre & " " & rsDatos.Papellido & " " & rsDatos.Papellido2
										,'á,é,í,ó,ú,Á,É,Í,Ó,Ú,ñ,Ñ,ü,Ü', 'a,e,i,o,u,A,E,I,O,U,n,N,u,U')>
	<cfoutput>
		<cfscript>
			function eliminaInvalidos(cadenaValida,aValidar){
				var retCadena = "";

				for (pos = 1; pos LE Len(aValidar); pos=pos + 1) {// ver cada letra
					if (REFindNoCase( '[#cadenaValida#]', Mid(aValidar,pos,1))) { // es válida ?
						retCadena = retCadena & Mid(aValidar,pos,1); // usarla
					}
					if(Mid(aValidar,pos,1) EQ ' '){
						retCadena = retCadena & Mid(aValidar,pos,1); // usarla					
					}
				}

				return retCadena;
			}
			
			function alerta(cadena){
				WriteOutput("<script>alert('" & cadena & "');</script>");
			}		
		
			CNFormat = eliminaInvalidos('#url.validCaracts#',CNFormat);
			s = ListToArray( LCase(CNFormat), " ");
			
			set = ArrayNew(1); // new TreeSet()
			year = Year(Now());
			sug = ArrayToList(s,"");
			
			for (i = 1; i LE ArrayLen(s); i = i + 1) {
				sug = "";
				for (j = 1; j LE ArrayLen(s); j = j + 1) {
					sug = sug & IIf(i EQ j, "s[j]", "Left(s[j], 1)" );
					if (Len(sug) GTE 6 and Len(sug) LTE 16) {
						ArrayAppend(set, sug);
					}
					if (Len(sug & Right(year, 2)) GTE 6 and Len(sug & Right(year, 2)) LTE 16) {
						ArrayAppend(set, sug & Right(year, 2));
					}
					if (Len(sug & year) GTE 6 and Len(sug & year) LTE 16) {
						ArrayAppend(set, sug & year);
					}
				}
			}
		</cfscript>
	</cfoutput>
	
		<cfquery name="repetidos" datasource="#session.dsn#">
			select LGlogin
			from ISBlogin
			where LGlogin in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(set)#" list="yes" separator=",">)
			<cfif isdefined("url.LGnumero") and Len(Trim(url.LGnumero))>
			  and LGnumero <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.LGnumero#">
			</cfif>
		</cfquery>
		<cfset reps = ValueList(repetidos.LGlogin)>
	
	
		<form name="form1" method="post" onsubmit="return ValidaConlis(this);" style="margin: 0;" action="<cfoutput>#GetFileFromPath(GetTemplatePath())#</cfoutput>">
			<input type="hidden" name="f" value="<cfoutput>#url.f#</cfoutput>">
			<input type="hidden" name="sufijo" value="<cfoutput>#url.sufijo#</cfoutput>">
			<input type="hidden" name="Pquien" value="<cfoutput>#url.Pquien#</cfoutput>">
			<input type="hidden" name="LGnumero" value="<cfoutput>#url.LGnumero#</cfoutput>">
			<table width="100%" border="0" cellspacing="0" cellpadding="2">
			  <tr>
				<td colspan="2" style="color:#FF0000;">
					El login que usted escogi&oacute; ya existe. Intente de nuevo.
				</td>
			  </tr>
			  <tr>
				<td align="right" valign="top" rowspan="2">Seleccione un nuevo login:</td>
				<td>			
					<select name="login" onChange="document.form1.logintext.value = this.value;document.form1.logintext.style.visibility=this.value==''?'visible':'hidden';" >
						<cfloop from="1" to="#ArrayLen(set)#" index="i">							
							<cfoutput>							
								<cfif (i EQ 1 OR set[i] NEQ set[i-1]) and ListFind(reps, set[i]) EQ 0>
									<option value="#set[i]#">#set[i]#</option>
								</cfif>
							</cfoutput>
						</cfloop>
						<option value="" selected>Especificar...</option>
					</select>
				</td>
			  </tr>
			  <tr>
				<td>
					<input type="text" name="logintext" size="20" maxlength="16" onFocus="this.select()" value="" />
				</td>
			  </tr>
			  <tr>
				<td colspan="2" align="center">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2" align="center">
					<input type="submit" name="Enviar" value="Enviar"/>
				</td>
			  </tr>
			</table>
		</form>
	
		<script language="javascript" type="text/javascript">
			function ValidaConlis(formulario) {
			var error_input;
			var error_msg = '';
			
				if (formulario.login && formulario.login.value == '') {
				error_msg += "\n - Seleccione un nuevo login.";
				error_input = formulario.login;}
			
				if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;}
			}		
		</script>
	</cfif>

</body>
</html>
