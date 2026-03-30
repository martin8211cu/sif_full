
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Posibles_Candidatos"
		Default="Posibles Candidatos"
		returnvariable="LB_Posibles_Candidatos"/>	
		
		<cfset CorreoPara 	= form.CORREOPARA>
		<cfset CorreoDe 	= form.CORREODE>
		<cfset Asunto    	= LB_Posibles_Candidatos>

		<cfsavecontent variable="_mail_body">
		<table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid #999999; ">
			<tr bgcolor="#003399">
			  <td colspan="2" height="24"></td>
			</tr>
			<tr bgcolor="#999999">
			  <td colspan="2"> <strong><cfoutput>#LB_Posibles_Candidatos#</cfoutput></strong> </td>
			</tr>
			
			<tr>
			<tr>
			  <td colspan="2" ><span>
			  <cf_translate  key="LB_Adjuntamos_en_este_correo_la_informacion_de_los_siguientes_candidatos_para_reclutamiento_y_seleccion">Adjuntamos en este correo la informaci&oacute;n de los siguientes candidatos para reclutamiento y selecci&oacute;n</cf_translate>
			  </span></td>
			</tr>
			<td colspan="2">
			<table border="0" width="100%">
			<cfif isdefined("form.CONDICIONES") and len(trim(form.CONDICIONES))>
				<tr>
				  <td colspan="4" ><span>
				  <cf_translate  key="LB_Se_utilizaron_los_siguientes_criterios_de_b&uacute;squeda">Se utilizaron los siguientes criterios de b&uacute;squeda</cf_translate>
				  </span></td>
				</tr>
				<tr>
				  <td  width="10%"></td>
				  <td  width="25%"></td>
				  <td  width="10%"></td>
				  <td ></td>
				</tr> 
				
				<cfset moneda = "">
				<cfset montoinf = -1>
				<cfset montosup = -1>
				<cfset experiencia = "">
				<cfset expinf = -1>
				<cfset expsup = -1>
				<cfset cierra = 0>
				
				<cfset ListaFitros = listtoarray(form.CONDICIONES,"&")>
				<cfloop from="1" to ="#arraylen(ListaFitros)#" index="i">
					<cfset Listavalores = listtoarray(ListaFitros[i],"=")>
						<cfif Listavalores[1] eq 'RHOsexo'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td ><span style="font-size:10px"><strong><cf_translate  key="LB_Sexo">Sexo</cf_translate></strong></span></td>
								  <td > <span style="font-size:10px">
									<cfswitch expression="#Listavalores[2]#">
											<cfcase value="F">
											<cf_translate key="LB_Femenino">Femenino</cf_translate>
											</cfcase>
											<cfcase value="M">
												<cf_translate key="LB_Masculino">Masculino</cf_translate>
											</cfcase>
									</cfswitch>
								   </span></td>
							<cfelse>
								  <td ><span style="font-size:10px"><strong><cf_translate  key="LB_Sexo">Sexo</cf_translate></strong></span></td>
								  <td > <span style="font-size:10px">
									<cfswitch expression="#Listavalores[2]#">
											<cfcase value="F">
											<cf_translate key="LB_Femenino">Femenino</cf_translate>
											</cfcase>
											<cfcase value="M">
												<cf_translate key="LB_Masculino">Masculino</cf_translate>
											</cfcase>
									</cfswitch>
								   </span></td>
								</tr>
								<cfset cierra = 0>	
							</cfif>	
						</cfif>
						<cfif Listavalores[1] eq 'Ppais'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Nacionalidad">Nacionalidad </cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfquery name="rsPais" datasource="asp">
										select Pnombre 
										from Pais
										where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Listavalores[2]#">
									</cfquery>
									<cfoutput>#rsPais.Pnombre#</cfoutput>
								   </span></td>
							<cfelse>
								<cfset cierra = 0>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Nacionalidad">Nacionalidad </cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfquery name="rsPais" datasource="asp">
										select Pnombre 
										from Pais
										where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Listavalores[2]#">
									</cfquery>
									<cfoutput>#rsPais.Pnombre#</cfoutput>
								   </span></td>
								</tr>
							</cfif>
						</cfif>
						<cfif Listavalores[1] eq 'RHOMonedaPrt'>
							<cfset moneda = Listavalores[2]>
						</cfif>
						<cfif Listavalores[1] eq 'RHOPrenteInf'>
							<cfset montoinf = Listavalores[2]>
						</cfif>
						<cfif Listavalores[1] eq 'RHOPrenteSup'>
							<cfset montosup = Listavalores[2]>
						</cfif>
						<cfif Listavalores[1] eq 'TPOEXPE'>
							<cfset experiencia = Listavalores[2]>
						</cfif>
						<cfif Listavalores[1] eq 'ExperienciaSup'>
							<cfset expsup = Listavalores[2]>
						</cfif>
						<cfif Listavalores[1] eq 'ExperienciaInf'>
							<cfset expinf = Listavalores[2]>
						</cfif>
						<cfif Listavalores[1] eq 'RHPcodigo'>
							<cfquery name="rsPuesto" datasource="#session.DSN#">
								select 	
									coalesce(ltrim(rtrim(RHPcodigoext)),rtrim(ltrim(RHPcodigo))) as RHPcodigoext,
									RHPdescpuesto
								from RHPuestos
								where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Listavalores[2]#">
							</cfquery>
							
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_PuestoInterno">Puesto Interno</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#rsPuesto.RHPcodigoext#&nbsp;#rsPuesto.RHPdescpuesto#</cfoutput>
								   </span></td>
							<cfelse>
								<cfset cierra = 0>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_PuestoInterno">Puesto Interno</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#rsPuesto.RHPcodigoext#&nbsp;#rsPuesto.RHPdescpuesto#</cfoutput>
								   </span></td>
								</tr>
							</cfif>
							
						</cfif>
						<cfif Listavalores[1] eq 'RHOPid'>
							<cfquery name="rsPUESTOEXT" datasource="#session.DSN#">
								select 	
									RHOPid, 
									RHOPDescripcion
								from RHOPuesto
								where  CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
								and RHOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Listavalores[2]#">
							</cfquery>
							
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_PuestoExterno">Puesto Externo</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#rsPUESTOEXT.RHOPDescripcion#</cfoutput>
								   </span></td>
							<cfelse>
								<cfset cierra = 0>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_PuestoExterno">Puesto Externo</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#rsPUESTOEXT.RHOPDescripcion#</cfoutput>
								   </span></td>
								</tr>
							</cfif>
						</cfif>
						<cfif Listavalores[1] eq 'CapNoFormal'>
							
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_CapacitacionNoFormal">Capacitaci&oacute;n No formal</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#Listavalores[2]#</cfoutput>
								   </span></td>
							<cfelse>
								<cfset cierra = 0>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_CapacitacionNoFormal">Capacitaci&oacute;n No formal</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#Listavalores[2]#</cfoutput>
								   </span></td>
								</tr>
							</cfif>
						</cfif>	
						<cfif Listavalores[1] eq 'Zona1'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Zona1">Zona 1</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#Listavalores[2]#</cfoutput>
								   </span></td>
							<cfelse>
								<cfset cierra = 0>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Zona1">Zona 1</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#Listavalores[2]#</cfoutput>
								   </span></td>
								</tr>
							</cfif>
							
						</cfif>	
						<cfif Listavalores[1] eq 'Zona2'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Zona2">Zona 2</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#Listavalores[2]#</cfoutput>
								   </span></td>
							<cfelse>
								<cfset cierra = 0>	
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Zona2">Zona 2</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#Listavalores[2]#</cfoutput>
								   </span></td>
								</tr>
							</cfif>
						</cfif>
						<cfif Listavalores[1] eq 'Zona3'>
							
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Zona3">Zona 3</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#Listavalores[2]#</cfoutput>
								   </span></td>
							<cfelse>
								<cfset cierra = 0>	
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Zona3">Zona 3</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfoutput>#Listavalores[2]#</cfoutput>
								   </span></td>
								</tr>
							</cfif>
						</cfif>
						<cfif Listavalores[1] eq 'RHOIdioma'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Idiomas">Idiomas</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfset Listaidiomas = listtoarray(Listavalores[2],",")>
									<cfloop from="1" to ="#arraylen(Listaidiomas)#" index="x">
									<cfswitch expression="#Listaidiomas[x]#">
										<cfcase value="1">
											<cf_translate key="LB_ALEMAN">ALEMAN</cf_translate>
										</cfcase>
										<cfcase value="2">
											<cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate>
										</cfcase>
										<cfcase value="3">
											<cf_translate key="LB_FRANCES">FRANCES</cf_translate>
										</cfcase>
										<cfcase value="4">
											<cf_translate key="LB_INGLES">INGLES</cf_translate>
										</cfcase>
										<cfcase value="5">
											<cf_translate key="LB_ITALIANO">ITALIANO</cf_translate>
										</cfcase>
										<cfcase value="6">
											<cf_translate key="LB_JAPONES">JAPONES</cf_translate>
										</cfcase>
										<cfcase value="7">
											<cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate>
										</cfcase>
									</cfswitch>&nbsp;								
									</cfloop>
								   </span></td>
							<cfelse>
								<cfset cierra = 0>	
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Idiomas">Idiomas</cf_translate></strong></span></td>
								  <td> <span style="font-size:10px">
									<cfset Listaidiomas = listtoarray(Listavalores[2],",")>
									<cfloop from="1" to ="#arraylen(Listaidiomas)#" index="x">
									<cfswitch expression="#Listaidiomas[x]#">
										<cfcase value="1">
											<cf_translate key="LB_ALEMAN">ALEMAN</cf_translate>
										</cfcase>
										<cfcase value="2">
											<cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate>
										</cfcase>
										<cfcase value="3">
											<cf_translate key="LB_FRANCES">FRANCES</cf_translate>
										</cfcase>
										<cfcase value="4">
											<cf_translate key="LB_INGLES">INGLES</cf_translate>
										</cfcase>
										<cfcase value="5">
											<cf_translate key="LB_ITALIANO">ITALIANO</cf_translate>
										</cfcase>
										<cfcase value="6">
											<cf_translate key="LB_JAPONES">JAPONES</cf_translate>
										</cfcase>
										<cfcase value="7">
											<cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate>
										</cfcase>
									</cfswitch>&nbsp;								
									</cfloop>
								   </span></td>
								</tr>
							</cfif>
						</cfif>
						<cfif Listavalores[1] eq 'RHCGIDLIST'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Estudios">Estudios</cf_translate></strong></span></td>
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="MSG_Cualquier_nivel"
									Default="Cualquier nivel"
									returnvariable="MSG_Cualquier_nivel"/>	
									<cfset estudios = listtoarray(Listavalores[2])>	
									<td >
									<cfloop from="1" to ="#arraylen(estudios)#" index="z">
										<cfset arreglo2 = listtoarray(estudios[z],'|')>	
										<cfquery name="rsNivel" datasource="#session.DSN#">
											select 	
												GAnombre
											from GradoAcademico
											where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and    GAcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[1]#">
										</cfquery>
										<cfquery name="rsTitulo" datasource="#session.DSN#">
											select 	
												RHOTDescripcion
											from RHOTitulo
											where  CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
											and    RHOTid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[2]#">
										</cfquery>
										<cfif arreglo2[1] eq '-1'>
											<cfset descripcion = '( '& MSG_Cualquier_nivel & ' ) ' & rsTitulo.RHOTDescripcion>
										<cfelse>
											<cfset descripcion = '( '& rsNivel.GAnombre & ' ) ' & rsTitulo.RHOTDescripcion>
										</cfif>
										  <span style="font-size:10px"><cfoutput>#descripcion#</cfoutput></span>&nbsp;
									</cfloop>	
									</td>
							<cfelse>
								<cfset cierra = 0>	
								  <td><span style="font-size:10px"><strong><cf_translate  key="LB_Estudios">Estudios</cf_translate></strong></span></td>
									<cfinvoke component="sif.Componentes.Translate"
									method="Translate"
									Key="MSG_Cualquier_nivel"
									Default="Cualquier nivel"
									returnvariable="MSG_Cualquier_nivel"/>	
									<cfset estudios = listtoarray(Listavalores[2])>	
									<td >
									<cfloop from="1" to ="#arraylen(estudios)#" index="z">
										<cfset arreglo2 = listtoarray(estudios[z],'|')>	
										<cfquery name="rsNivel" datasource="#session.DSN#">
											select 	
												GAnombre
											from GradoAcademico
											where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
											and    GAcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[1]#">
										</cfquery>
										<cfquery name="rsTitulo" datasource="#session.DSN#">
											select 	
												RHOTDescripcion
											from RHOTitulo
											where  CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
											and    RHOTid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[2]#">
										</cfquery>
										<cfif arreglo2[1] eq '-1'>
											<cfset descripcion = '( '& MSG_Cualquier_nivel & ' ) ' & rsTitulo.RHOTDescripcion>
										<cfelse>
											<cfset descripcion = '( '& rsNivel.GAnombre & ' ) ' & rsTitulo.RHOTDescripcion>
										</cfif>
										  <span style="font-size:10px"><cfoutput>#descripcion#</cfoutput></span>&nbsp;
									</cfloop>	
									</td>
								</tr>
							</cfif>
						</cfif>	
						<cfif Listavalores[1] eq 'RHORefValida'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								   <td></td>
								  <td colspan="1"><span style="font-size:10px"><cf_translate key="CHK_ReferenciaVerificadas">Referencias verificadas</cf_translate></span></td>
							<cfelse>
								<cfset cierra = 0>
								   <td></td>
								  <td colspan="1"><span style="font-size:10px"><cf_translate key="CHK_ReferenciaVerificadas">Referencias verificadas</cf_translate></span></td>
								</tr>	
							</cfif>
						</cfif>	
						<cfif Listavalores[1] eq 'RHOPosViajar'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								  <td></td>
								  <td colspan="1"><span style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_viajar ">Posibilidad de viajar</cf_translate></span></td>
							<cfelse>
								<cfset cierra = 0>	
								  <td></td>
								  <td colspan="1"><span style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_viajar ">Posibilidad de viajar</cf_translate></span></td>
								</tr>
							</cfif>
						</cfif>	
						<cfif Listavalores[1] eq 'RHOPosTralado'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								 <td></td>
								  <td colspan="1"><span style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_trasladarse_a_otra_ciudad_y/o_pais">Posibilidad de trasladarse a otra ciudad y/o pa&iacute;s</cf_translate></span></td>
							<cfelse>
								<cfset cierra = 0>	
								   <td></td>
								  <td colspan="1"><span style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_trasladarse_a_otra_ciudad_y/o_pais">Posibilidad de trasladarse a otra ciudad y/o pa&iacute;s</cf_translate></span></td>
								</tr>
							</cfif>
						</cfif>	
						<cfif Listavalores[1] eq 'RHOEntrevistado'>
							<cfif cierra EQ 0>
								<cfset cierra = 1>
								<tr>
								   <td></td>
								  <td colspan="1"><span style="font-size:10px"><cf_translate key="CHK_Entrevistado">Entrevistado(a)</cf_translate></span></td>
							<cfelse>
								<cfset cierra = 0>	
								   <td></td>
								  <td colspan="1"><span style="font-size:10px"><cf_translate key="CHK_Entrevistado">Entrevistado(a)</cf_translate></span></td>
								</tr>
							</cfif>
						</cfif>
				</cfloop>
				<cfset experiencia = "">
				
				<cfif montoinf neq -1 or  montosup neq -1 >
					<cfif cierra EQ 0>
						<cfset cierra = 1>
						<tr>
						  <td><span style="font-size:10px"><strong><cf_translate key="LB_Pretencion_salarial">Pretenci&oacute;n salarial</cf_translate></span></td>
						  <td> <span style="font-size:10px">
							<cfif montoinf neq -1 and  montosup neq -1>
								<cfoutput><cf_translate key="LB_Entre">Entre</cf_translate>(#moneda#)&nbsp;#montoinf#&nbsp;<cf_translate key="LB_y">y</cf_translate>&nbsp; #montosup#</cfoutput>
							<cfelseif montoinf eq -1 and  montosup neq -1>
								<cfoutput><cf_translate key="LB_Mas_de">Mas de</cf_translate>&nbsp;(#moneda#)&nbsp; #montosup#</cfoutput>
							<cfelseif montoinf neq -1 and  montosup eq -1>
								<cfoutput><cf_translate key="LB_Menos_de">menos de</cf_translate>&nbsp;(#moneda#)&nbsp; #montoinf#</cfoutput>
							</cfif>
						   </span></td>
					<cfelse>
						<cfset cierra = 0>	
						  <td><span style="font-size:10px"><strong><cf_translate key="LB_Pretencion_salarial">Pretenci&oacute;n salarial</cf_translate></span></td>
						  <td> <span style="font-size:10px">
							<cfif montoinf neq -1 and  montosup neq -1>
								<cfoutput><cf_translate key="LB_Entre">Entre</cf_translate>(#moneda#)&nbsp;#montoinf#&nbsp;<cf_translate key="LB_y">y</cf_translate>&nbsp; #montosup#</cfoutput>
							<cfelseif montoinf eq -1 and  montosup neq -1>
								<cfoutput><cf_translate key="LB_Mas_de">Mas de</cf_translate>&nbsp;(#moneda#)&nbsp; #montosup#</cfoutput>
							<cfelseif montoinf neq -1 and  montosup eq -1>
								<cfoutput><cf_translate key="LB_Menos_de">menos de</cf_translate>&nbsp;(#moneda#)&nbsp; #montoinf#</cfoutput>
							</cfif>
						   </span></td>
						</tr>
					</cfif>
				</cfif>
				<cfif expinf neq -1 or  expsup neq -1>
					<cfif cierra EQ 0>
						<cfset cierra = 1>
						<tr>
						  <td><span style="font-size:10px"><strong><cf_translate key="LB_Experiencia">Experiencia</cf_translate></span></td>
						  <td> <span style="font-size:10px">
							<cfif expsup neq -1>
								<cfoutput><cf_translate key="LB_Mas_de">Mas de</cf_translate>&nbsp;#expsup#&nbsp;<cf_translate key="LB_Annos">a&ntilde;os</cf_translate></cfoutput>
							<cfelseif expinf neq -1>
								<cfoutput><cf_translate key="LB_Menos_de">menos de</cf_translate>&nbsp;#expinf#</cfoutput>
							</cfif>
						   </span></td>
					<cfelse>
						<cfset cierra = 0>	
						  <td><span style="font-size:10px"><strong><cf_translate key="LB_Experiencia">Experiencia</cf_translate></span></td>
						  <td> <span style="font-size:10px">
							<cfif expsup neq -1>
								<cfoutput><cf_translate key="LB_Mas_de">Mas de</cf_translate>&nbsp;#expsup#&nbsp;<cf_translate key="LB_Annos">a&ntilde;os</cf_translate></cfoutput>
							<cfelseif expinf neq -1>
								<cfoutput><cf_translate key="LB_Menos_de">menos de</cf_translate>&nbsp;#expinf#</cfoutput>
							</cfif>
						   </span></td>
						</tr>
					</cfif>
				</cfif>
				<cfif cierra EQ 1>
					</tr>
				</cfif>
			</table>
			</td>
			</tr>	
			<cfelse>
				<tr>
				  <td colspan="2"><span style="font-size:10px"><strong>
				  <cf_translate  key="LB_Estos_son_los_posibles_obtenidos">Estos son los posibles candidatos obtenidos:</cf_translate>
				  </strong></span></td>
				</tr>
			</cfif>
			<tr>
				<td colspan="2">
					<cfif isdefined("form.CHK") and len(trim(form.CHK))>
						<cfset oferentes = listtoarray(form.CHK)>	
						<cfloop from="1" to ="#arraylen(oferentes)#" index="i">
							<!--- ************************************************************************************************************************************ --->
							<!--- Información general del oferente  --->
							<cfquery name="rsMonedaLOC" datasource="#Session.DSN#">
								select Miso4217  from Monedas a
								inner join Empresa b
									on a. Mcodigo = b. Mcodigo
									and b.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.ecodigosdc#">
								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							</cfquery>
							<cfquery name="rsDatosPersonales" datasource="#session.DSN#">
								select 
								a.RHOnombre,a.RHOapellido1,a.RHOapellido2, 
								a.RHOtelefono1,
								a.RHOtelefono2,
								b.NTIdescripcion,
								a.RHOidentificacion,
								a.RHOemail,
								a.RHOfechanac,
								a.RHOPrenteInf,
								a.RHOPrenteSup, 
								coalesce(a.RHOMonedaPrt,'#rsMonedaLOC.Miso4217#') as RHOMonedaPrt,
								a.RHOIdioma1,
								a.RHOIdioma2,
								a.RHOIdioma3
								from DatosOferentes a
								inner join NTipoIdentificacion b
									on a.NTIcodigo = b.NTIcodigo
									and b.Ecodigo = #Session.Ecodigo#
								where  a.RHOid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#oferentes[i]#">
								and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							</cfquery>
							
							<cfquery name="rsAnnosExperiencia" datasource="#Session.DSN#">
								select coalesce(sum(RHEEAnnosLab),0)  as RHEEAnnosLab
								from RHExperienciaEmpleado b 
								where b.RHOid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#oferentes[i]#">
							</cfquery>
							
							<cfquery name="rsExperiencia" datasource="#Session.DSN#">
								select 
									RHEEnombreemp,
									RHEEpuestodes,
									RHEEfechaini,
									RHEEfecharetiro
								from RHExperienciaEmpleado where RHOid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#oferentes[i]#">
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								order by RHEEfechaini desc
							</cfquery>
							
							<cf_dbfunction name="length" args="RHECapNoFormal" returnvariable="LenRHECapNoFormal">
							<cfquery name="rsEducFormal" datasource="#Session.DSN#">
								select  coalesce(RHIAnombre,RHEotrains)as institucion,
								a.RHEfechaini,
								RHOTDescripcion as titulo,
								coalesce(GAnombre,'<cf_translate key="Sin_defini">Sin definir</cf_translate>') as grado,
								RHEsinterminar 
								from RHEducacionEmpleado a
								left outer join RHInstitucionesA b
									on a.RHIAid = b.RHIAid
									and a.Ecodigo = b.Ecodigo
								inner join RHOTitulo c
									on a.RHOTid  =  c.RHOTid 
									and c.CEcodigo = #Session.CEcodigo#
								left outer  join GradoAcademico d
									on a.GAcodigo =  d.GAcodigo
									and a.Ecodigo = d.Ecodigo
								where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#oferentes[i]#">
								and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and RHECapNoFormal is null
								order by RHEsinterminar  desc,a.RHEfechaini desc
							</cfquery>
							
							<cfquery name="rsEducNoFormal" datasource="#Session.DSN#">
								select  coalesce(RHIAnombre,RHEotrains)as institucion,
								a.RHEfechaini,
								RHECapNoFormal as titulo,
								coalesce(GAnombre,'<cf_translate key="Sin_defini">Sin definir</cf_translate>') as grado,
								RHEsinterminar 
								from RHEducacionEmpleado a
								left outer join RHInstitucionesA b
									on a.RHIAid = b.RHIAid
									and a.Ecodigo = b.Ecodigo
								left outer  join GradoAcademico d
									on a.GAcodigo =  d.GAcodigo
									and a.Ecodigo = d.Ecodigo
								where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#oferentes[i]#"> 
								and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								and RHECapNoFormal is not  null
								
								order by RHEsinterminar  desc,a.RHEfechaini desc
							</cfquery>
							
							<cfoutput>
							<table  width="100%" border="0"  cellpadding="2" cellspacing="2">
								<tr>
									<td style="font-size:15px" valign="top" bgcolor="##CCCCCC" colspan="4">
										<strong>#rsDatosPersonales.RHOnombre#&nbsp;#rsDatosPersonales.RHOapellido1#&nbsp;#rsDatosPersonales.RHOapellido2#</strong>
										</font>
									</td>
								</tr>
								<tr>
									<td colspan="4"><hr></td>
								</tr>
								<tr>
									<td style="font-style:italic; font-size:12px" width="40%" valign="top">
										<fieldset><legend><cf_translate key="DatosGenerales">DATOS GENERALES</cf_translate></legend>
											<table  width="100%" border="0"  cellpadding="2" cellspacing="2">
												<tr>
													<td style="font-size:9px" width="16%">
														<b><cf_translate key="LB_#rsDatosPersonales.NTIdescripcion#">#rsDatosPersonales.NTIdescripcion#</cf_translate></b>:
													</td>
													<td style="font-size:9px" >
														#rsDatosPersonales.RHOidentificacion#
													</td>
												</tr>
												<tr>
													<td style="font-size:9px">
														<b><cf_translate key="LB_FechaDeNacimiento">Fecha de Nacimiento</cf_translate></b>:
													</td>
													<td style="font-size:9px">
														#LSDateFormat(rsDatosPersonales.RHOfechanac, "dd/mm/yyyy")#
													</td>
												</tr>	
												<tr>
													<td style="font-size:9px">
														<b><cf_translate key="LB_Telefono">Tel&eacute;fono</cf_translate></b>:
													</td>
													<td style="font-size:9px">
														#rsDatosPersonales.RHOtelefono1#
													</td>
												</tr>
												<tr>
													<td style="font-size:9px">
														<b><cf_translate key="LB_Celular">Celular</cf_translate></b>:
													</td>
													<td style="font-size:9px">
														#rsDatosPersonales.RHOtelefono2#
													</td>
												</tr>
												<tr>
													<td style="font-size:9px">
														<b><cf_translate key="LB_CorreoElectronico">Correo Electr&oacute;nico</cf_translate></b>:
													</td>
													<td style="font-size:9px">
														#rsDatosPersonales.RHOemail#
													</td>
												</tr>
												<tr>
													<td style="font-size:9px">
														<b><cf_translate key="LB_Aspiracion_Salarial">Aspiraci&oacute;n Salarial</cf_translate></b>:
													</td>
													<td style="font-size:9px">
														<cfif isdefined("rsDatosPersonales.RHOMonedaPrt") and len(trim(rsDatosPersonales.RHOMonedaPrt))>
															(#rsDatosPersonales.RHOMonedaPrt#)
														<cfelse>
															(#rsMonedaLOC.Miso4217#)
														</cfif>
														&nbsp;#LSNumberFormat(rsDatosPersonales.RHOPrenteInf,"___,.__")#
														<cf_translate key="LB_A">a</cf_translate>
														&nbsp;#LSNumberFormat(rsDatosPersonales.RHOPrenteSup,"___,.__")#
													</td>
												</tr>
												<tr>
													<td style="font-size:9px" >
														<b><cf_translate key="LB_Idioma">Idioma</cf_translate></b>:
													</td>
												<cfif (isdefined("rsDatosPersonales.RHOIdioma1") and len(trim(rsDatosPersonales.RHOIdioma1))) or
												  (isdefined("rsDatosPersonales.RHOIdioma2") and len(trim(rsDatosPersonales.RHOIdioma2))) or 
												  (isdefined("rsDatosPersonales.RHOIdioma3") and len(trim(rsDatosPersonales.RHOIdioma3)))>
												  <td style="font-size:9px" colspan="2">
													<cfif (isdefined("rsDatosPersonales.RHOIdioma1") and len(trim(rsDatosPersonales.RHOIdioma1)))>
														<cfswitch expression="#rsDatosPersonales.RHOIdioma1#">
															<cfcase value="1">
																<cf_translate key="LB_ALEMAN">ALEMAN</cf_translate>
															</cfcase>
															<cfcase value="2">
																<cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate>
															</cfcase>
															<cfcase value="3">
																<cf_translate key="LB_FRANCES">FRANCES</cf_translate>
															</cfcase>
															<cfcase value="4">
																<cf_translate key="LB_INGLES">INGLES</cf_translate>
															</cfcase>
															<cfcase value="5">
																<cf_translate key="LB_ITALIANO">ITALIANO</cf_translate>
															</cfcase>
															<cfcase value="6">
																<cf_translate key="LB_JAPONES">JAPONES</cf_translate>
															</cfcase>
															<cfcase value="7">
																<cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate>
															</cfcase>
															<cfcase value="8">
																<cf_translate key="LB_MANDARIN">MANDARIN</cf_translate>
															</cfcase>
														</cfswitch>&nbsp;									
													</cfif>
													<cfif (isdefined("rsDatosPersonales.RHOIdioma2") and len(trim(rsDatosPersonales.RHOIdioma2)))>
														<cfswitch expression="#rsDatosPersonales.RHOIdioma2#">
															<cfcase value="1">
																<cf_translate key="LB_ALEMAN">ALEMAN</cf_translate>
															</cfcase>
															<cfcase value="2">
																<cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate>
															</cfcase>
															<cfcase value="3">
																<cf_translate key="LB_FRANCES">FRANCES</cf_translate>
															</cfcase>
															<cfcase value="4">
																<cf_translate key="LB_INGLES">INGLES</cf_translate>
															</cfcase>
															<cfcase value="5">
																<cf_translate key="LB_ITALIANO">ITALIANO</cf_translate>
															</cfcase>
															<cfcase value="6">
																<cf_translate key="LB_JAPONES">JAPONES</cf_translate>
															</cfcase>
															<cfcase value="7">
																<cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate>
															</cfcase>
															<cfcase value="8">
																<cf_translate key="LB_MANDARIN">MANDARIN</cf_translate>
															</cfcase>
														</cfswitch>&nbsp;								
													</cfif>
													<cfif (isdefined("rsDatosPersonales.RHOIdioma3") and len(trim(rsDatosPersonales.RHOIdioma3)))>
														<cfswitch expression="#rsDatosPersonales.RHOIdioma3#">
															<cfcase value="1">
																<cf_translate key="LB_ALEMAN">ALEMAN</cf_translate>
															</cfcase>
															<cfcase value="2">
																<cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate>
															</cfcase>
															<cfcase value="3">
																<cf_translate key="LB_FRANCES">FRANCES</cf_translate>
															</cfcase>
															<cfcase value="4">
																<cf_translate key="LB_INGLES">INGLES</cf_translate>
															</cfcase>
															<cfcase value="5">
																<cf_translate key="LB_ITALIANO">ITALIANO</cf_translate>
															</cfcase>
															<cfcase value="6">
																<cf_translate key="LB_JAPONES">JAPONES</cf_translate>
															</cfcase>
															<cfcase value="7">
																<cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate>
															</cfcase>
															<cfcase value="8">
																<cf_translate key="LB_MANDARIN">MANDARIN</cf_translate>
															</cfcase>
														</cfswitch>&nbsp;								
													</cfif>
												 </td>	
												<cfelse>
													<td style="font-size:9px" >
														<cf_translate key="LB_No_se_han_definido_lenguajes">No se han definido lenguajes</cf_translate>
													</td>
												</cfif>  
												</tr>
											</table>
										</fieldset>
									<!--- 
									</td>
									<td style="font-style:italic; font-size:12px" width="25%" valign="top">
									 --->
										<fieldset><legend><cf_translate key="EXPERIENCIA_LABORAL">EXPERIENCIA LABORAL</cf_translate></legend>
											<table  width="100%" border="0"  cellpadding="2" cellspacing="2">
												<tr>
													<td style="font-size:10px" colspan="3" align="center">
														<strong><cf_translate key="Annos_de_experiencia">A&ntilde;os de experiencia</cf_translate>&nbsp; #rsAnnosExperiencia.RHEEAnnosLab#</strong>
													</td>
												</tr>
												<cfif rsExperiencia.recordCount GT 0>
													<cfloop query="rsExperiencia">
														<tr>
															<td style="font-size:9px" colspan="3">
																<b>#rsExperiencia.RHEEnombreemp#</b>
															</td>
														</tr>
														<tr>
															<td style="font-size:9px" width="3%" rowspan="2" >&nbsp;
																
															</td>
															<td style="font-size:9px" width="15%"  nowrap>
																<cf_translate key="LB_Cargo">Cargo</cf_translate>:
															</td>
															<td style="font-size:9px"> 
																#rsExperiencia.RHEEpuestodes#
															</td>
														</tr>
														<tr>	
															<td style="font-size:9px" nowrap >
																<cf_translate key="LB_Tiempo_Laborado">Tiempo Laborado</cf_translate>:
															</td>
															<td style="font-size:9px"> 
																<cfif isdefined("rsExperiencia.RHEEfechaini") and len(trim(rsExperiencia.RHEEfechaini))> 
																	<cfswitch expression="#month(rsExperiencia.RHEEfechaini)#">
																		<cfcase value="1">
																			<cf_translate key="LB_ENERO">Enero</cf_translate>
																		</cfcase>
																		<cfcase value="2">
																			<cf_translate key="LB_Febrero">Febrero</cf_translate>
																		</cfcase>
																		<cfcase value="3">
																			<cf_translate key="LB_Marzo">Marzo</cf_translate>
																		</cfcase>
																		<cfcase value="4">
																			<cf_translate key="LB_Abril">Abril</cf_translate>
																		</cfcase>
																		<cfcase value="5">
																			<cf_translate key="LB_Mayo">Mayo</cf_translate>
																		</cfcase>
																		<cfcase value="6">
																			<cf_translate key="LB_Junio">Junio</cf_translate>
																		</cfcase>
																		<cfcase value="7">
																			<cf_translate key="LB_Julio">Julio</cf_translate>
																		</cfcase>
																		<cfcase value="8">
																			<cf_translate key="LB_Agosto">Agosto</cf_translate>
																		</cfcase>
																		<cfcase value="9">
																			<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
																		</cfcase>
																		<cfcase value="10">
																			<cf_translate key="LB_Octubre">Octubre</cf_translate>
																		</cfcase>
																		<cfcase value="11">
									
																			<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
																		</cfcase>
																		<cfcase value="12">
																			<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
																		</cfcase>
																		
																	</cfswitch>
																	
																	&nbsp; 
																		#year(rsExperiencia.RHEEfechaini)#
																	&nbsp; 
																</cfif>
																<cfif isdefined("rsExperiencia.RHEEfecharetiro") and len(trim(rsExperiencia.RHEEfecharetiro))> 
																	<cfif year(rsExperiencia.RHEEfecharetiro) neq 6100 >
																		<cf_translate key="LB_al">al</cf_translate>
																		&nbsp;
																		<cfswitch expression="#month(rsExperiencia.RHEEfecharetiro)#">
																			<cfcase value="1">
																				<cf_translate key="LB_ENERO">Enero</cf_translate>
																			</cfcase>
																			<cfcase value="2">
																				<cf_translate key="LB_Febrero">Febrero</cf_translate>
																			</cfcase>
																			<cfcase value="3">
																				<cf_translate key="LB_Marzo">Marzo</cf_translate>
																			</cfcase>
																			<cfcase value="4">
																				<cf_translate key="LB_Abril">Abril</cf_translate>
																			</cfcase>
																			<cfcase value="5">
																				<cf_translate key="LB_Mayo">Mayo</cf_translate>
																			</cfcase>
																			<cfcase value="6">
																				<cf_translate key="LB_Junio">Junio</cf_translate>
																			</cfcase>
																			<cfcase value="7">
																				<cf_translate key="LB_Julio">Julio</cf_translate>
																			</cfcase>
																			<cfcase value="8">
																				<cf_translate key="LB_Agosto">Agosto</cf_translate>
																			</cfcase>
																			<cfcase value="9">
																				<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
																			</cfcase>
																			<cfcase value="10">
																				<cf_translate key="LB_Octubre">Octubre</cf_translate>
																			</cfcase>
																			<cfcase value="11">
																				<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
																			</cfcase>
																			<cfcase value="12">
																				<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
																			</cfcase>
																			
																		</cfswitch>									
																		&nbsp; 
																		#year(rsExperiencia.RHEEfecharetiro)#
																	<cfelse>
																		<cf_translate key="LB_Hasta_la_fecha">Hasta la fecha</cf_translate>
																	</cfif>
																</cfif>
															</td>
														</tr>							
													</cfloop>
												<cfelse>
													<tr> 
														<td style="font-size:9px" colspan="3">
															<cf_translate key="LB_No_se_ha_definido_experiencia_laboral">No se ha definido experiencia laboral</cf_translate>
														</td>
													</tr>					
												</cfif>	
											</table>
										</fieldset>
									</td>
									<td style="font-style:italic; font-size:12px" width="50%" valign="top">
										<fieldset><legend><cf_translate key="ESTUDIOS_FORMALES">ESTUDIOS FORMALES</cf_translate></legend>
											<table  width="100%" border="0"  cellpadding="2" cellspacing="2">
												<cfif rsEducFormal.recordCount GT 0>
													<cfloop query="rsEducFormal">
														<tr>
															<td style="font-size:9px" colspan="2">
																<b>#rsEducFormal.institucion#</b>
															</td>
														</tr>
														<tr>
															<td style="font-size:9px" width="3%" rowspan="3">&nbsp;</td>
															<td style="font-size:9px"> 
																<cfif isdefined("rsEducFormal.RHEfechaini") and len(trim(rsEducFormal.RHEfechaini))> 
																	<cfswitch expression="#month(rsEducFormal.RHEfechaini)#">
																		<cfcase value="1">
																			<cf_translate key="LB_ENERO">Enero</cf_translate>
																		</cfcase>
																		<cfcase value="2">
																			<cf_translate key="LB_Febrero">Febrero</cf_translate>
																		</cfcase>
																		<cfcase value="3">
																			<cf_translate key="LB_Marzo">Marzo</cf_translate>
																		</cfcase>
																		<cfcase value="4">
																			<cf_translate key="LB_Abril">Abril</cf_translate>
																		</cfcase>
																		<cfcase value="5">
																			<cf_translate key="LB_Mayo">Mayo</cf_translate>
																		</cfcase>
																		<cfcase value="6">
																			<cf_translate key="LB_Junio">Junio</cf_translate>
																		</cfcase>
																		<cfcase value="7">
																			<cf_translate key="LB_Julio">Julio</cf_translate>
																		</cfcase>
																		<cfcase value="8">
																			<cf_translate key="LB_Agosto">Agosto</cf_translate>
																		</cfcase>
																		<cfcase value="9">
																			<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
																		</cfcase>
																		<cfcase value="10">
																			<cf_translate key="LB_Octubre">Octubre</cf_translate>
																		</cfcase>
																		<cfcase value="11">
																			<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
																		</cfcase>
																		<cfcase value="12">
																			<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
																		</cfcase>
																	</cfswitch>
																	&nbsp; 
																	#year(rsEducFormal.RHEfechaini)#
																</cfif>									
															</td>
														</tr>
														<tr>
															<td style="font-size:9px"> 
																#rsEducFormal.grado#
															</td>
														</tr>						
														<tr>
															<td style="font-size:9px"> 
																#rsEducFormal.titulo#
															</td>
														</tr>
																		
													</cfloop>
												<cfelse>
													<tr> 
														<td style="font-size:9px" colspan="2">
															<cf_translate key="LB_No_se_ha_definido_educacacion_formal">No se ha definido educaci&oacute;n formal</cf_translate>
														</td>
													</tr>
												</cfif>					
											</table>
										</fieldset>	
									<!--- 
									</td>
									<td style="font-style:italic; font-size:12px" width="25%" valign="top">
									 --->
										 <fieldset><legend><cf_translate key="ESTUDIOS_NO_FORMALES">ESTUDIOS NO FORMALES</cf_translate></legend>
											<table  width="100%" border="0"  cellpadding="2" cellspacing="2">
												<cfif rsEducNoFormal.recordCount GT 0>
													<cfloop query="rsEducNoFormal">
														<tr>
															<td style="font-size:9px" colspan="2">
																<b>#rsEducNoFormal.institucion#</b>
															</td>
														</tr>
														<tr>
															<td style="font-size:9px" width="3%" rowspan="3">&nbsp;</td>
															<td style="font-size:9px"> 
																<cfif isdefined("rsEducFormal.RHEfechaini") and len(trim(rsEducFormal.RHEfechaini))> 
																	<cfswitch expression="#month(rsEducNoFormal.RHEfechaini)#">
																		<cfcase value="1">
																			<cf_translate key="LB_ENERO">Enero</cf_translate>
																		</cfcase>
																		<cfcase value="2">
																			<cf_translate key="LB_Febrero">Febrero</cf_translate>
																		</cfcase>
																		<cfcase value="3">
																			<cf_translate key="LB_Marzo">Marzo</cf_translate>
																		</cfcase>
																		<cfcase value="4">
																			<cf_translate key="LB_Abril">Abril</cf_translate>
																		</cfcase>
																		<cfcase value="5">
																			<cf_translate key="LB_Mayo">Mayo</cf_translate>
																		</cfcase>
																		<cfcase value="6">
																			<cf_translate key="LB_Junio">Junio</cf_translate>
																		</cfcase>
																		<cfcase value="7">
																			<cf_translate key="LB_Julio">Julio</cf_translate>
																		</cfcase>
																		<cfcase value="8">
																			<cf_translate key="LB_Agosto">Agosto</cf_translate>
																		</cfcase>
																		<cfcase value="9">
																			<cf_translate key="LB_Setiembre">Setiembre</cf_translate>
																		</cfcase>
																		<cfcase value="10">
																			<cf_translate key="LB_Octubre">Octubre</cf_translate>
																		</cfcase>
																		<cfcase value="11">
																			<cf_translate key="LB_Noviembre">Noviembre</cf_translate>
																		</cfcase>
																		<cfcase value="12">
																			<cf_translate key="LB_Diciembre">Diciembre</cf_translate>
																		</cfcase>
																	</cfswitch>
																	&nbsp; 
																	#year(rsEducNoFormal.RHEfechaini)#
																</cfif>								
															</td>
														</tr>						
														<tr>
															<td style="font-size:9px"> 
																#rsEducNoFormal.grado#
															</td>
														</tr>					
														<tr>
															<td style="font-size:9px"> 
																#rsEducNoFormal.titulo#
															</td>
														</tr>
													</cfloop>
												<cfelse>
													<tr> 
														<td style="font-size:9px" colspan="2">
															<cf_translate key="LB_No_se_ha_definido_educacacion_no_formal">No se ha definido educaci&oacute;n no formal</cf_translate>
								
														</td>
													</tr>
												</cfif>					
											</table>
										</fieldset>					
									</td>
								</tr>	
							</table>
							</cfoutput>
							<!--- ************************************************************************************************************************************ --->
						</cfloop>
					</cfif>
				</td>
			</tr>
		</table>	
		</cfsavecontent>
		 <cfquery datasource="asp">
			insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
			values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#CorreoDe#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#CorreoPara#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Asunto#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#_mail_body#">, 1)
		</cfquery>
