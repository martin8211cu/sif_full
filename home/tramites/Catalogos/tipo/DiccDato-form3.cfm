<html>
<head>
<cf_templatecss>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<cfinclude template="DiccDato-config.cfm">
<cfset diccdatoui = CreateObject("component", "diccdatoui")>
<cfset modoDet = "ALTA">
<cfquery datasource="#session.tramites.dsn#" name="enc_tipo">
	select a.es_persona, ti.id_tipoident, ti.nombre_tipoident
	from DDTipo a
		left join TPTipoIdent ti
			on ti.id_tipo = a.id_tipo
	where a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipo#">
</cfquery>
<cfquery datasource="#session.tramites.dsn#" name="otros">
		select
			max(cast(es_descripcion as integer)) as es_descripcion,
			max(cast(es_obligatorio as integer)) as es_obligatorio,
			max(cast(es_llave       as integer)) as es_llave
		from DDTipoCampo a
		where a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipo#">
	</cfquery>
<cfif isdefined("url.id_campo")>
  <cfset modoDet = "CAMBIO">
  <cfquery name="rsTipoCampo" datasource="#session.tramites.dsn#">
		select 	a.id_tipo,
				a.id_campo,
				a.nombre_campo,
				a.id_tipocampo,
				b.nombre_tipo, 
				b.clase_tipo,
				b.es_documento,b.tipo_dato,b.nombre_tabla,b.longitud,b.escala,
				b.nombre_tabla,
				(select nombre_documento from TPDocumento dc where dc.id_tipo = b.id_tipo) as nombre_documento,
				a.es_obligatorio,
				a.es_descripcion,
				a.es_llave,
				a.orden_campo
		from DDTipoCampo a
			inner join DDTipo b
				on b.id_tipo = a.id_tipocampo
		where a.id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_campo#">
		and a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipo#">
	</cfquery>
</cfif>
<cfquery name="rsLista" datasource="#session.tramites.dsn#">
		select 	a.id_tipo,
				a.id_campo,
				a.nombre_campo,
				a.id_tipocampo,
				b.nombre_tipo, 
				b.es_persona,
				b.clase_tipo,
				'' as tipo,
				b.nombre_tabla,
				a.es_obligatorio,
				a.es_descripcion,
				a.orden_campo,
				b.es_documento,b.tipo_dato,b.nombre_tabla,b.longitud,b.escala,
				(select nombre_documento from TPDocumento dc where dc.id_tipo = b.id_tipo) as nombre_documento,
				case when a.es_llave      =1 then 'I' else null end ||
				case when a.es_obligatorio=1 then 'R' else null end ||
				case when a.es_descripcion=1 then 'L' else null end 
				as flgs,
				dtkey.nombre_campo as nombre_campo2,
				dtkey2.clase_tipo as clase_tipo2,
				dtkey2.es_documento as es_documento2,
				dtkey2.tipo_dato as tipo_dato2,
				dtkey2.nombre_tabla as nombre_tabla2,
				dtkey2.longitud as longitud2,
				dtkey2.escala as escala2,
				(select nombre_documento from TPDocumento dc where dc.id_tipo = dtkey2.id_tipo)
				as nombre_documento2
				
				
		from DDTipoCampo a
			inner join DDTipo b
				on b.id_tipo = a.id_tipocampo
			left join DDTipoCampo dtkey <!--- detalle de un tipo complejo --->
				on dtkey.id_tipo = a.id_tipocampo
				and dtkey.es_llave = 1
			left join DDTipo dtkey2
				on dtkey2.id_tipo = dtkey.id_tipocampo
		where a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipo#">
		order by a.orden_campo, b.clase_tipo desc, a.nombre_campo
	</cfquery>
<cfloop query="rsLista">
  <cfset rsLista.tipo  = diccdatoui.describeClaseyTipo (es_documento,clase_tipo,tipo_dato,nombre_tabla,longitud,escala,nombre_documento)>
</cfloop>
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	<cfif modoDet EQ "CAMBIO">
		<cfoutput>
		function funcBaja() {
			if (confirm('Esta seguro de que desea eliminar el campo #rsTipoCampo.nombre_campo# de la composicion del tipo de dato #rsTipoDato.nombre_tipo#?')) {
				return true;
			} else {
				return false;
			}
		}
		
		function funcNuevo() {
			location.href = '#CurrentPage#?id_tipo=#url.id_tipo#'; 
			return false;
		}
		</cfoutput>
	</cfif>
</script>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">
        <cfoutput><cfif Len(enc_tipo.id_tipoident)>
		<em>Este documento est&aacute; asociado 
		siempre a un(a) #HTMLEditFormat(enc_tipo.nombre_tipoident)#, por lo que no necesita
		incluir  los siguentes datos:
		<ul>
		<li>Número de identificaci&oacute;n</li>
		<li>Nombre</li>
		<cfif enc_tipo.es_persona EQ 1>
		<li>Apellidos</li>
		<li>Fecha de nacimiento</li>
		<li>Sexo</li>
		<li>Teléfono</li>
		<li>Correo electrónico</li></cfif>
		</ul></em>
	<cfelse>
        <!--- no mostrar cuando es un tipo de identificacion --->
          <form name="form4" method="post" action="DiccDato-sql-form3.cfm">
            <input type="hidden" name="CambioEsPersona" value="1">
            <input type="hidden" name="id_tipo" value="<cfif isdefined("url.id_tipo") and Len(Trim(url.id_tipo))>#url.id_tipo#</cfif>">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td valign="top"><input type="checkbox" name="es_persona" id="es_persona" onClick="this.form.submit()" <cfif enc_tipo.es_persona EQ 1>checked</cfif>></td>
                <td valign="top"><label for="es_persona"><strong>Asociar siempre los documentos de este tipo a una persona</strong></label></td>
              </tr>
            </table>
          </form>
      </cfif>
        </cfoutput>
    </td>
    <td width="50%" rowspan="2" valign="top"><cfoutput>
        <form name="form1" method="post" action="DiccDato-sql-form3.cfm">
          <input type="hidden" name="id_tipo" value="<cfif isdefined("url.id_tipo") and Len(Trim(url.id_tipo))>#url.id_tipo#</cfif>">
          <input type="hidden" name="id_campo" value="<cfif isdefined("url.id_campo") and Len(Trim(url.id_campo))>#url.id_campo#</cfif>">
          <table width="400"  border="0" cellspacing="0" cellpadding="2" align="center">
            <tr>
              <td bgcolor="##ECE9D8" align="center" class="tituloIndicacion"><strong>
                <cfif modoDet EQ "ALTA">
                  Agregar
                  <cfelse>
                  Modificar
                </cfif>
                Campo</strong> </td>
            </tr>
            <tr>
              <td>&nbsp;</td>
            </tr>
          </table>
          <table width="400"  border="0" align="center" cellpadding="2" cellspacing="0">
            <tr>
              <td nowrap class="fileLabel">&nbsp;</td>
              <td colspan="2" nowrap class="fileLabel"><span class="fileLabel">Nombre:</span></td>
            </tr>
            <tr>
              <td nowrap class="fileLabel">&nbsp;</td>
              <td colspan="2" nowrap class="fileLabel"><input type="text" name="nombre_campo" size="60" maxlength="100" value="<cfif modoDet EQ "CAMBIO">#HtmlEditFormat(rsTipoCampo.nombre_campo)#</cfif>">
              </td>
            </tr>
            <tr>
              <td nowrap class="fileLabel">&nbsp;</td>
              <td colspan="2" nowrap class="fileLabel"><span class="fileLabel">Tipo:</span></td>
            </tr>
            <tr>
              <td nowrap class="fileLabel">&nbsp;</td>
              <td colspan="2" nowrap class="fileLabel"><table width="1%" border="0" cellspacing="0" cellpadding="0" style="border:0px;">
                  <tr>
                    <td>
					<input type="hidden" name="id_tipocampo" value="<cfif isdefined('rsTipoCampo')>#HTMLEditFormat(rsTipoCampo.id_tipocampo)#</cfif>">
                    </td>
                    <td>
					<input type="text" name="nombre_tipo" value="<cfif isdefined('rsTipoCampo')>#HTMLEditFormat( diccdatoui.describeClase (rsTipoCampo.es_documento,rsTipoCampo.clase_tipo,rsTipoCampo.tipo_dato,rsTipoCampo.nombre_tabla,rsTipoCampo.longitud, rsTipoCampo.escala,rsTipoCampo.nombre_documento))#</cfif>" size="20" readonly>
                    </td>
                    <td><input type="text" name="tipo" value="<cfif isdefined('rsTipoCampo')>#HTMLEditFormat(diccdatoui.describeTipo (rsTipoCampo.es_documento,rsTipoCampo.clase_tipo,	rsTipoCampo.tipo_dato,rsTipoCampo.nombre_tabla,rsTipoCampo.longitud, rsTipoCampo.escala,rsTipoCampo.nombre_documento))#</cfif>" size="30" readonly>
                    </td>
                    <td><a href="javascript:doConlisid_tipocampo();" tabindex="-1"> <img src="/cfmx/sif/imagenes/Description.gif"
				alt="Lista de Tipos"
				name="imagenid_tipocampo"
				width="18" height="14"
				border="0" align="absmiddle"> </a> </td>
                  </tr>
                </table></td>
            </tr>
            <tr>
              <td nowrap class="fileLabel">&nbsp;</td>
              <td colspan="2" nowrap class="fileLabel"><span class="fileLabel">Orden:</span></td>
            </tr>
            <tr>
              <td nowrap class="fileLabel">&nbsp;</td>
              <td colspan="2" nowrap class="fileLabel"><input name="orden_campo" id="orden_campo" type="text" size="8" maxlength="6" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modoDet EQ "CAMBIO" and Len(Trim(rsTipoCampo.orden_campo))>#LSNumberFormat(rsTipoCampo.orden_campo,'9')#</cfif>">
              </td>
            </tr>
            <tr>
              <td width="9%" valign="top" nowrap class="fileLabel">&nbsp;</td>
              <td width="5%" valign="top" nowrap class="fileLabel"><input name="es_llave" type="checkbox" id="es_llave" value="1" <cfif (modoDet EQ "CAMBIO" and rsTipoCampo.es_llave EQ 1) OR (modoDet EQ 'ALTA' AND otros.es_llave EQ 0)> checked</cfif>>
              </td>
              <td width="86%" valign="top"><label for="es_llave"><strong>I</strong>dentificador &uacute;nico <br>
                <em><strong>(tambi&eacute;n conocido como llave primaria)</strong></em></label></td>
            </tr>
            <tr>
              <td class="fileLabel" nowrap valign="top">&nbsp;</td>
              <td class="fileLabel" nowrap valign="top"><input name="es_obligatorio" type="checkbox" id="es_obligatorio" value="1" <cfif (modoDet EQ "CAMBIO" and rsTipoCampo.es_obligatorio EQ 1) OR (modoDet EQ 'ALTA' AND otros.es_obligatorio EQ 0)> checked</cfif>>
              </td>
              <td valign="top"><label for="es_obligatorio"><strong>R</strong>equerido cuando se captura</label></td>
            </tr>
            <tr>
              <td class="fileLabel" valign="top" nowrap>&nbsp;</td>
              <td class="fileLabel" valign="top" nowrap><input name="es_descripcion" type="checkbox" id="es_descripcion" value="1" <cfif (modoDet EQ "CAMBIO" and rsTipoCampo.es_descripcion EQ 1) OR (modoDet EQ 'ALTA' AND otros.es_descripcion EQ 0)> checked</cfif>></td>
              <td valign="top"><label for="es_descripcion">Mostrar en las listas de datos</label></td>
            </tr>
            <tr>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr>
              <td colspan="3" align="center"><cf_botones modo="#modoDet#"> </td>
            </tr>
          </table>
        </form>
      </cfoutput></td>
  </tr>
  <tr>
    <td width="50%" valign="top" align="center"><div style="height: 280; width: 100%; overflow: auto;">
        <table cellpadding="2" cellspacing="0" border="0" width="100%">
          <tr>
            <td width="43" class="tituloListas"><strong>&nbsp;</strong></td>
            <td width="28" class="tituloListas"><strong>N&deg;</strong></td>
            <td colspan="2" class="tituloListas"><strong>Nombre</strong></td>
            <td colspan="2" class="tituloListas"><strong>Tipo</strong></td>
            <td width="41" class="tituloListas"><strong>&nbsp;</strong></td>
          </tr>
          <cfset rowno=0>
          <cfoutput query="rsLista" group="id_campo">
            <cfset rowno=rowno+1>
            <cfset par=IIf(rowno Mod 2, DE('Non'), DE('Par'))>
            <tr class="lista#par#" id="listrow_#rowno#_0"
				onmouseover="cchh('#rowno#','lista#par#Sel')" 
				onmouseout="cchh('#rowno#','lista#par#')" 
				style="cursor:pointer; " onClick="editar('#JSStringFormat(id_campo)#')">
              <td valign="top"><cfif IsDefined('url.id_campo') and (url.id_campo eq rsLista.id_campo)>
                  <img src="/cfmx/sif/imagenes/addressGo.gif" width="18" height="18">
				  <cfelse>&nbsp;
                </cfif></td>
              <td valign="top">#HTMLEditFormat(orden_campo)#</td>
              <td colspan="2" valign="top"><a name="campo#id_campo#"></a>
			  #HTMLEditFormat(nombre_campo)#</td>
              <td colspan="2" valign="top">#HTMLEditFormat(tipo)#</td>
              <td valign="top"><cfif Len(flgs)>#HTMLEditFormat(flgs)#<cfelse>&nbsp;</cfif></td>
            </tr>
            <cfif clase_tipo EQ 'C'>
              <cfif es_persona EQ '1'>
                <tr class="lista#par#"id="listrow_#rowno#_1" onMouseOver="cchh('#rowno#','lista#par#Sel')" 
				onmouseout="cchh('#rowno#','lista#par#')" style="cursor:pointer; " onClick="editar('#JSStringFormat(id_campo)#')">
                  <td colspan="2" valign="top">&nbsp;</td>
                  <td width="20" valign="top">&nbsp;</td>
                  <td colspan="2" valign="top">Identificaci&oacute;n Personal </td>
                  <td colspan="2" valign="top"><em>Tipo y número</em></td>
                </tr>
              </cfif>
			  <cfset rrnn=1>
              <cfoutput>
                <cfif Len(nombre_campo2)>
					<cfset rrnn = rrnn+1>
                  <tr class="lista#par#" id="listrow_#rowno#_#rrnn#" onMouseOver="cchh('#rowno#','lista#par#Sel')" 
				onmouseout="cchh('#rowno#','lista#par#')" style="cursor:pointer; " onClick="editar('#JSStringFormat(id_campo)#')" >
                    <td colspan="2" valign="top">&nbsp;</td>
                    <td colspan="1" valign="top">&nbsp;&nbsp;&nbsp; </td>
                    <td colspan="2" valign="top">
					#HTMLEditFormat(nombre_campo2)#
					  <cfset descr = diccdatoui.describeClaseyTipo (
						es_documento2,clase_tipo2,tipo_dato2,nombre_tabla2,
							longitud2,escala2,nombre_documento2)></td>
                    <td colspan="2" valign="top"><em>#HTMLEditFormat( descr )#</em></td>
                  </tr>
                </cfif>
              </cfoutput>
            </cfif>
          </cfoutput>
				  <tr><td height="5"></td><td></td><td></td><td width="201"></td><td width="20"></td><td width="161"></td><td></td></tr>
        </table>
        <cfif rsLista.RecordCount EQ 0>
          <strong>- No se han definido campos de informaci&oacute;n adicional -</strong>
        </cfif>
      </div></td>
  </tr>
</table>
<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.nombre_campo.description = "Nombre";
	objForm.nombre_campo.required = true;
	objForm.id_tipocampo.description = "Tipo";
	objForm.id_tipocampo.required = true;
	
	
	var popUpWinid_tipocampo=null;
	function popUpWindowid_tipocampo(URLStr, left, top, width, height)
	{
	  if(popUpWinid_tipocampo)
	  {
		if(!popUpWinid_tipocampo.closed) popUpWinid_tipocampo.close();
	  }
	  popUpWinid_tipocampo = open(URLStr, 'popUpWinid_tipocampo', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function doConlisid_tipocampo(){
		var conlisArgs = '';
		<cfoutput>
		popUpWindowid_tipocampo('DiccDato-conlis.cfm?id_tipopadre=#URLEncodedFormat(url.id_tipo)#',
			250,200,650,700);
		</cfoutput>
	}
	function editar(id_campo)
	{
		<cfoutput>
		location.href = '?id_tipo=#URLEncodedFormat(url.id_tipo)#&id_campo='
			+ escape(id_campo) <!--- + '##campo' + escape(id_campo) --->;
		</cfoutput>
	}
	
	function cchh(rowno,style){
		for(i=0;i<100;i++){
			x = document.getElementById('listrow_'+rowno+'_'+i);
			if (i>2&&!x) break;
			if(x)x.className=style;
		}
	}
	
</script>
</body>
</html>
