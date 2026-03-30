<!--- Rodolfo Jimenez Jara, Soluciones Integrales S.A., Costa Rica, America Central, 21/04/2003 --->
	
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


<cfif isdefined("Url.btnGenerar") and not isdefined("Form.btnGenerar")>
	<cfset Form.btnGenerar = Url.btnGenerar>
</cfif>

<cfif isdefined("Url.codigo") and not isdefined("Form.codigo")>
	<cfset Form.codigo = Url.codigo>
</cfif>

<cfif isdefined("Url.id_documento") and not isdefined("Form.id_documento")>
	<cfset Form.id_documento = Url.id_documento>
</cfif>

<cfif isdefined("Url.tipo") and not isdefined("Form.tipo")>
	<cfset Form.tipo = Url.tipo>
</cfif>	
	
<cfif isdefined("Url.atributo") and not isdefined("Form.atributo")>
	<cfset Form.atributo = Url.atributo>
</cfif>

<cfif isdefined("Url.valor") and not isdefined("Form.valor")>
	<cfset Form.valor = Url.valor>
</cfif>

<cfif isdefined("Url.tipo_contenido") and not isdefined("Form.tipo_contenido")>
	<cfset Form.tipo_contenido = Url.tipo_contenido>
</cfif>	
	

			
<script language="JavaScript" src="../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	function  fnConsultarDoc(doc,tipo,t_contenido, nombre, atributo, t_atributo, valor)
	{
		if (t_contenido == 'I' || t_contenido == 'T' || t_contenido == 'D'  || t_contenido == 'L' ) {
			link="/cfmx/edu/responsable/ConlisBusquedaMaterial.cfm?tipo="+tipo+"&documento="+doc+"&id_atributo="+atributo+"&tipo_atributo="+t_atributo+"&id_valor="+valor;
			LvarWin = window.open(link, "ConsultaMaterial", "left=100,top=50,scrollbars=yes,resizable=yes,width=600,height=300,alwaysRaised=yes");
			LvarWin.focus();
			return;
		} 
		else if (t_contenido == 'L') {
		 	link=""+nombre
			LvarWin = window.open(link);
			LvarWin.focus();
			return;
		}
	}
</script>
	<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">		
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td bgcolor="#FFFFFF" style="border: 1px solid black; padding: 3px;">
							<b>Nota: </b>Para descargar un archivo, ver una imagen o visitar un link haga click en los &iacute;conos<br>
							Para ver el detalle del material did&aacute;ctico haga click en el t&iacute;tulo del material
						</td>
					</tr>
					<tr> 
                      <td> 
					  	<cfset filtro = "">
					  	<cfset navegacion = ""> 
						<cfif isdefined('form.btnGenerar') >
							<cfset navegacion = "btnGenerar=" & form.btnGenerar>
						</cfif>
					  	<cfif isdefined('form.codigo') and form.codigo NEQ '-1' and len(trim(form.codigo)) NEQ 0>
							<cfset filtro = #filtro# & " and DMT.MTcodigo = " & #form.codigo# >
							<cfset navegacion = "codigo=" & form.codigo>
						</cfif>
						<cfif isdefined('form.id_documento') and form.id_documento NEQ '-1' and len(trim(form.id_documento)) NEQ 0>
							<cfset filtro = #filtro# & " and MAD.id_documento = " & #form.id_documento# >
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "id_documento=" & Form.id_documento>			
						</cfif>
						<cfif isdefined('form.tipo') and form.tipo NEQ '-1' and len(trim(form.tipo)) NEQ 0>
							<cfset filtro = #filtro# & " and MAD.id_tipo = " & #form.tipo# >
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "tipo=" & Form.tipo>				
						</cfif>
						<cfif isdefined('form.atributo') and form.atributo NEQ '-1' and len(trim(form.atributo)) NEQ 0>
							<cfset filtro = #filtro# & " and MAA.id_atributo = " & #form.atributo# >
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "atributo=" & Form.atributo>							
						</cfif>
						<cfif isdefined('form.valor') and form.valor NEQ '-1' and len(trim(form.valor)) NEQ 0>
							<cfset filtro = #filtro# & " and MAAD.id_valor = " & #form.valor# >
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "valor=" & Form.valor>
						</cfif>
						<cfif isdefined('form.tipo_contenido') and form.tipo_contenido NEQ '-1' and len(trim(form.tipo_contenido)) NEQ 0>
							<cfset filtro = #filtro# & " and MAD.tipo_contenido = '" & #form.tipo_contenido# & "'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "tipo_contenido=" & Form.tipo_contenido>
						</cfif>
						
						<cfif isdefined('form.atributo') and form.atributo NEQ '-1' and isdefined('form.CDfecha') and len(trim(form.CDfecha)) NEQ 0 and isdefined('form.CDfechaFin') and len(trim(form.CDfechaFin)) NEQ 0 >
							<cfset filtro = #filtro# & " and convert(datetime,MAAD.valor,103) between convert(datetime, '" & #form.CDfecha# & "', 103)" & " and convert(datetime, '"& #form.CDfechaFin# & "', 103)">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDfecha=" & Form.CDfecha & DE("&") & "CDfechaFin=" & Form.CDfechaFin>
						<cfelseif isdefined('form.atributo') and form.atributo NEQ '-1' and isdefined('form.CDfecha') and len(trim(form.CDfecha)) NEQ 0 and isdefined('form.CDfechaFin') and len(trim(form.CDfechaFin)) EQ 0>	
							<cfset filtro = #filtro# & " and convert(datetime,MAAD.valor,103) >= convert(datetime,'" & #form.CDfecha# & "',103)">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDfecha=" & Form.CDfecha>
						<cfelseif isdefined('form.atributo') and form.atributo NEQ '-1' and isdefined('form.CDfecha') and len(trim(form.CDfecha)) EQ 0 and isdefined('form.CDfechaFin') and len(trim(form.CDfechaFin)) NEQ 0>	
							<cfset filtro = #filtro# & " and convert(datetime,MAAD.valor,103) <= convert(datetime,'" & #form.CDfechaFin# & "',103)">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CDfechaFin=" & Form.CDfechaFin>	
						</cfif>
								
						<cfif isdefined('form.atributo') and form.atributo NEQ '-1' and isdefined('form.t_numero') and len(trim(form.t_numero)) NEQ 0>
							<cfset filtro = #filtro# & " and convert(numeric,MAAD.valor) = " & #form.t_numero# >
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "t_numero=" & Form.t_numero>			
						</cfif>
						<cfif isdefined('form.atributo') and form.atributo NEQ '-1' and isdefined('form.texto') and len(trim(form.texto)) NEQ 0>
							<cfset filtro = #filtro# & " and upper(MAAD.valor) like '%" & Ucase(#form.texto#) & "%'">
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "texto=" & Form.texto >
						</cfif>

						<cfinvoke 
							 component="edu.Componentes.pListas"
							 method="pListaEdu"
							 returnvariable="pListaMADocumento">
                          <cfinvokeargument name="tabla" value="MADocumento MAD , BibliotecaCentroE BCE , MATipoDocumento MAT , DocumentoMateriaTipo  DMT , MAAtributo MAA , MAValorAtributo MAVA , MAAtributoDocumento MAAD, MateriaTipo MT"/>
						  <cfinvokeargument name="columnas" value="distinct convert(varchar,MAD.id_documento) as id_documento
												, convert(varchar,MAD.id_tipo) as id_tipo
												, MAD.titulo
												, convert(char,MAD.fecha,103) as fecha
												, MAT.nombre_tipo
												, MAD.tipo_contenido
												, substring(MT.MTdescripcion,1,35) as MTdescripcion
												, MAD.autor
												, case MAD.tipo_contenido when 'I' then '<img border=''0'' alt=''Ver Imagen'' src=''/cfmx/edu/Imagenes/eye.jpg''>' 
																		  when 'D' then '<a href=''/cfmx/edu/Utiles/downloadMA.cfm?cod='+convert(varchar,MAD.id_documento)+ ''' target=''_blank''>'+'<img border=''0'' alt=''Descargar Documento'' src=''/cfmx/edu/Imagenes/documento.gif''>' +'</a>' 
																		  when 'L' then '<a href='''+ MAD.nom_archivo + '''>'+'<img border=''0'' alt=''Visitar Link'' src=''/cfmx/edu/Imagenes/web.gif''>' +'</a>' 
																		  when 'T' then '<img border=''0'' alt=''Ver Texto'' src=''/cfmx/edu/Imagenes/texto.gif''>' else '' end as img_contenido 
												, case MAD.tipo_contenido when 'I' then 'Imagen' when 'D' then 'Documento' when 'L' then 'Link' when 'T' then 'Texto' else 'No definido' end as tipo 
												 "/>
						  <cfinvokeargument name="desplegar" value="titulo,  MTdescripcion, tipo, img_contenido"/>
                          <cfinvokeargument name="etiquetas" value="T&iacute;tulo, Tipo de Materia, Tipo de Contenido, "/>
                          <cfinvokeargument name="formatos" value=" , , ,L"/>
                          <cfinvokeargument name="filtro" value="BCE.CEcodigo = #Session.Edu.CEcodigo# 
													and MAT.id_biblioteca = BCE.id_biblioteca 
													and MAT.id_tipo = MAD.id_tipo 
													and MAD.id_documento = DMT.id_documento 
													and MT.MTcodigo = DMT.MTcodigo 
													and MAD.id_documento = MAAD.id_documento 
													and MAAD.id_atributo = MAA.id_atributo
													and MAAD.id_atributo *= MAVA.id_atributo
													and MAAD.id_valor *= MAVA.id_valor
													#filtro# order by MAD.id_tipo" />
                          <cfinvokeargument name="align" value="left, left, center, center"/>
                          <cfinvokeargument name="ajustar" value="N"/>
                          <cfinvokeargument name="funcion" value="fnConsultarDoc"/>
                          <cfinvokeargument name="fparams" value="id_documento, id_tipo, tipo_contenido "/>
						  <cfinvokeargument name="cortes" value="nombre_tipo"/>
						  <cfinvokeargument name="navegacion" value="#navegacion#"/>
						  <cfinvokeargument name="debug" value="N"/>
						   <cfinvokeargument name="maxrows" value="17"/>
                        </cfinvoke>								
						
					   </td>
                    </tr>
                  </table>
