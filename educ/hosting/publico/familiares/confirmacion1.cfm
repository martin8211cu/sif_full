<cfif isdefined("form.MEpersona2")>
	<cfset MODO = "CAMBIO">
	<cfif not isdefined("Form.Eliminar") or Form.Eliminar neq "S">
		<cfset TITULO = "Modificando datos personales de Mi Familiar.<br>">
	<cfelse>
		<cfset TITULO = "Eliminando Mi Familiar.<br>">
	</cfif>
	<cfset TITULO2 = "modificacion de datos personales de ">
<cfelse>
	<cfset MODO = "ALTA">
	<cfset TITULO = "Agregando un nuevo familiar">
	<cfset TITULO2 = "creación de un nuevo familiar">
</cfif>

<cfif isdefined("url.tipo") and len(trim(url.tipo)) gt 0>
	<cfset form.tipo = url.tipo>
</cfif>

<cfparam default="1" name="form.tipo" type="numeric"><!---	1 = Familiar que vive con la Persona.
														2 = Familiar que no vive con la Persona.
													--->
<cfif modo neq "ALTA">
	<cfset TITULO = TITULO & Form.Pnombre & ' ' & Form.Papellido1 & ' ' & Form.Papellido2>
	<cfset TITULO2 = TITULO2 & Form.Pnombre>
<cfelse>
	<cfif form.tipo eq 1>
		<cfset TITULO2 = TITULO2 & " que comparte mi domicilio">
	<cfelse>
		<cfset TITULO2 = TITULO2 & " que tiene diferente domicilio">
	</cfif>
</cfif>

<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsPaisDefault" datasource="asp">
	select Ppais
	from Empresa a, Direcciones b
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.cliente_empresarial#">
	and a.id_direccion = b.id_direccion
</cfquery>

<cfquery name="rsOcupaciones" datasource="#Session.DSN#">
	select convert(varchar, MEOid) as MEOid,
		   MEOnombre
	from MEOcupacion
	where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPaisDefault.Ppais#">
	and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">
	order by MEOnombre
</cfquery>

<cfquery name="rsParentescos" datasource="#Session.DSN#">
	select MEPid, MEPnombre
	from MEParentesco
	order by MEPnombre
</cfquery>

<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript1.4" type="text/javascript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</script>
<style type="text/css">
<!--
.style1 {color: #CCCCCC}
-->
</style>

<cf_template template="#session.sitio.template#">
<cf_templatearea name="left">
	<cfinclude template="../pMenu.cfm">
</cf_templatearea>
<cf_templatearea name="body">
<cfset navBarItems = ArrayNew(1)>
<cfset navBarLinks = ArrayNew(1)>
<cfset navBarStatusText = ArrayNew(1)>
<cfset Regresar = "javascript:history.back();">
<cfinclude template="../pNavegacion.cfm">
<div align="right"><img src="../images/Paso2.gif"></div>
<cfoutput>
	<form name="form1" id="form1" action="apply.cfm" method="post" enctype="multipart/form-data" style="margin:0">
		<input type="hidden" name="tipo" value="#Form.tipo#">
		<cfif modo neq "ALTA">
			<input type="hidden" name="Actualizar">
			<input type="hidden" name="Eliminar">
			<input type="hidden" name="MEpersona2" value="#Form.MEpersona2#">
		<cfelse>
			<input type="hidden" name="Registrar">
		</cfif>
		<table cellpadding="2" cellspacing="0" width="95%" align="center">
		  <tr>
		    <td width="2%" rowspan="18" align="center">&nbsp;</td>
			<td width="1%" nowrap class="fileLabel style1"><div align="left"></div></td>
			<th width="29%" align="right" nowrap class="fileLabel"><div align="left">Parentesco: </div></th>
		    <td width="65%" nowrap class="fileLabel">
			  <div align="left">
			    <input type="hidden" name="MEParentesco" id="MEParentesco" value="#Form.MEParentesco#">
			    <cfloop query="rsParentescos">
		            <cfif Form.MEParentesco eq MEPid>
		              #rsParentescos.MEPnombre#
                  </cfif>
	            </cfloop>
            </div></td>
		    
		    <td width="3%" nowrap class="fileLabel style1">&nbsp;</td>
	      </tr>
		  <tr>
		    <td align="right" nowrap>&nbsp;</td>
		    <th nowrap class="fileLabel"><div align="left"></div></th>
		    <td nowrap class="fileLabel"><div align="left"></div></td>
		    <td nowrap class="fileLabel">&nbsp;</td>
	      </tr>
		  <tr>
			<td align="right" nowrap>&nbsp;</td>
			<th nowrap class="fileLabel"><div align="left">Nombre: </div></th>
			<td nowrap class="fileLabel">
              <div align="left">
    <input name="Pnombre" type="hidden" value="#Trim(Form.Pnombre)#">
    #Trim(Form.Pnombre)# </div></td>
		    <td nowrap class="fileLabel">&nbsp;</td>
		  </tr>
		  <tr>
			<td align="right" nowrap>&nbsp;</td>
			<th nowrap><div align="left"><span class="fileLabel">Apellido 1: </span>
              </div></th>
			<td nowrap>
			  <div align="left">
			    <input name="Papellido1" type="hidden" value="#Trim(Form.Papellido1)#">
			    #Trim(Form.Papellido1)#
            </div></td>
		    <td nowrap>&nbsp;
			</td>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <th align="left" nowrap><div align="left"><span class="fileLabel">Apellido 2: </span></div></th>
		    <td align="right" nowrap class="fileLabel">
              <div align="left">
    <input name="Papellido2" type="hidden" value="#Trim(Form.Papellido2)#">
    #Trim(Form.Papellido2)# </div></td>
		    <td align="left" nowrap class="fileLabel">&nbsp;</td>
	      </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <th align="left" nowrap><div align="left"><span class="fileLabel">Nacimiento: </span></div></th>
		    <td align="right" nowrap class="fileLabel">
			  <div align="left">
    <cfset fecha = Form.Pnacimiento>
    <input type="hidden" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" name="Pnacimiento">
    #LSDateFormat(fecha,'dd/mm/yyyy')# </div></td>
		    <td align="left" nowrap class="fileLabel">&nbsp;</td>
	      </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>&nbsp;</td>
			<th align="left" nowrap><div align="left"><span class="fileLabel">Sexo:&nbsp; </span>
			          
		    </div></th>
			<td align="right" nowrap class="fileLabel">
			  <div align="left">
			    <input type="hidden" name="Psexo" value="#Form.Psexo#">
                <cfif Form.Psexo EQ 'M'>
                  Masculino
                    <cfelseif Form.Psexo EQ 'F'>
                    Femenino
                </cfif>
		      </div></td>
		    <td align="left" nowrap class="fileLabel">&nbsp;
			</td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <th class="fileLabel" align="right" nowrap><div align="left">Profesi&oacute;n: </div></th>
		    <td nowrap>
              <div align="left">
                <input type="hidden" name="MEOcupacion" id="MEOcupacion" value="#Form.MEOcupacion#">
                <cfif len(trim(Form.MEOcupacion)) neq 0>
                  <cfloop query="rsOcupaciones">
                    <cfif Form.MEOcupacion eq MEOid>
                      #rsOcupaciones.MEOnombre#
                    </cfif>
                  </cfloop>
                  <cfelse>
        Ninguna
                </cfif>
              </div></td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		  <tr>
		  	<td></td>
		    <th class="fileLabel" align="right" nowrap><div align="left">E-mail: </div></th>
		    <td nowrap>
			  <div align="left">
			    <input name="Pemail1" type="hidden" id="Pemail1" value="#Trim(Form.Pemail1)#">
			    #Trim(Form.Pemail1)#
            </div></td><td></td>
	      </tr>
		  <cfif form.tipo neq 1>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <th nowrap><div align="left"><span class="fileLabel">Direcci&oacute;n 1: </span></div></th>
		    <td align="right" nowrap class="fileLabel">
		      <div align="left">
  <input name="Pdireccion1" type="hidden" id="Pdireccion12" value="#Trim(Form.Pdireccion1)#">
  #Trim(Form.Pdireccion1)# </div></td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>&nbsp;</td>
			<th nowrap><div align="left"><span class="fileLabel">Direcci&oacute;n 2: </span></div></th>
			<td align="right" nowrap class="fileLabel">
			  <div align="left">
  <input name="Pdireccion2" type="hidden" id="Pdireccion22" value="#Trim(Form.Pdireccion2)#">
  #Trim(Form.Pdireccion2)#</div></td>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <th nowrap><div align="left"><span class="fileLabel">Ciudad: </span></div></th>
			<td align="right" nowrap class="fileLabel">
			  <div align="left">
  <input name="Pciudad" type="hidden" id="Pciudad2" value="#Trim(Form.Pciudad)#">
  #Trim(Form.Pciudad)#</div></td>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <th nowrap><div align="left"><span class="fileLabel">Estado: </span></div></th>
		    <td align="right" nowrap class="fileLabel">
		      <div align="left">
  <input name="Pprovincia" type="hidden" id="Pprovincia2" value="#Trim(Form.Pprovincia)#">
  #Trim(Form.Pprovincia)#</div></td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <th nowrap><div align="left">Pais: </div></th>
		    <td align="right" nowrap class="fileLabel"><div align="left">
				<input name="Ppais" type="hidden" value="#Form.Ppais#">
                <cfloop query="rsPais">
                  <cfif Compare(Trim(rsPais.Ppais), Form.Ppais) EQ 0>#rsPais.Pnombre#</cfif>
                </cfloop>
</div></td>
		    <td nowrap>&nbsp;</td>
		    </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <th nowrap><div align="left"><span class="fileLabel">C&oacute;digo Postal: </span></div></th>
		    <td align="right" nowrap class="fileLabel">
		      <div align="left">
  <input name="PcodPostal" type="hidden" id="PcodPostal2" value="#Trim(Form.PcodPostal)#">
  #Trim(Form.PcodPostal)#</div></td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		  </cfif>
		  <tr>
			<td></td>
			<th align="right" nowrap class="fileLabel"><div align="left">Tel. Diurno: </div></th>
		    <td nowrap>
			  <div align="left">
			    <input name="Poficina" type="hidden" id="Poficina" value="#Trim(Form.Poficina)#">
			    #Trim(Form.Poficina)#
	          </div></td>
				  <td></td>
	      </tr>
  		  <cfif form.tipo neq 1>
		  <tr>
			<td></td>
			<th align="right" nowrap class="fileLabel"><div align="left">Tel. Nocturno: </div></th>
		    <td nowrap>
			  <div align="left">
			    <input name="Pcasa" type="hidden" id="Pcasa" value="#Trim(Form.Pcasa)#">
			    #Trim(Form.Pcasa)#
	          </div></td>
				  <td></td>
	      </tr>
		  </cfif>
		  <tr>
			<td></td>
		    <th align="right" nowrap class="fileLabel"><div align="left">Tel. Celular: </div></th>
			<td nowrap>
			  <div align="left">
			    <input name="Pcelular" type="hidden" id="Pcelular" value="#Trim(Form.Pcelular)#">
			    #Trim(Form.Pcelular)#
	          </div></td><td></td>
		  </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		</table>
	</form>
	
	<table width="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="##EEEEEE">
      <cfif not isdefined("Form.Eliminar") or Form.Eliminar neq "S">
	  <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para confirmar el proceso de <cfoutput>#TITULO2#</cfoutput>, presione este botón.</td>
        <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=5,0,0,0" width="100" height="22">
          <param name="BGCOLOR" value="">
          <param name="movie" value="images/continuar2.swf">
          <param name="quality" value="high">
          <embed src="images/continuar2.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
        </object></td>
        <td>&nbsp;</td>
      </tr>
	  <cfelse>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para eliminar a este familiar, presione este bot&oacute;n. </td>
        <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=5,0,0,0" width="100" height="22">
            <param name="BGCOLOR" value="">
            <param name="movie" value="images/eliminar1.swf">
            <param name="quality" value="high">
            <embed src="images/eliminar1.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
        </object></td>
        <td>&nbsp;</td>
      </tr>
	  </cfif>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para corregir la informaci&oacute;n, presione este bot&oacute;n. </td>
        <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=5,0,0,0" width="100" height="22">
          <param name="BGCOLOR" value="">
          <param name="movie" value="images/regresar2.swf">
          <param name="quality" value="high">
          <embed src="images/regresar2.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
        </object></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
    </table>
	<p>&nbsp;</p>
	<p>&nbsp;</p>	
	
</cfoutput>
</cf_templatearea>
<cf_templatearea name="title">
	<cfoutput>
		#TITULO#<br>
		<cfif modo neq "ALTA" and (not isdefined("Form.Eliminar") or Form.Eliminar neq "S")>
			Se modificará este familiar con los siguientes datos.
		<cfelseif modo neq "ALTA">
			Se eliminará el siguiente familiar.
		<cfelse>
			Se creará un registro de un nuevo familiar con los siguientes datos.
		</cfif>
	</cfoutput>
</cf_templatearea>
</cf_template>