<!---DEid,eval,puesto,-2,deidevaluador,1 --->

<!---
,24843|108|SG0600|-2|24959|1
 --->


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_El_cuestionario_no_ha_sido_respondido_aun_por_lo_tanto_no_se_puede_finalizar"
Default="El cuestionario no ha sido respondido a&uacute;n, por lo tanto no se puede Finalizar"
returnvariable="MG_El_cuestionario_no_ha_sido_respondido_aun_por_lo_tanto_no_se_puede_finalizar"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_Advertencia_NoPuedeFinalizar"
Default="Advertencia: No se puede Finalizar"
returnvariable="MG_Advertencia_NoPuedeFinalizar"/> 


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_Preguntas_No_se_han_contestado"
Default="No se ha contestado "
returnvariable="MG_Preguntas_No_se_han_contestado"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_Preguntas"
Default=" preguntas "
returnvariable="MG_Preguntas"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_De"
Default=" de "
returnvariable="MG_De"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="MG_Advertencia_Debe_contestar_Todas"
Default="Advertencia: Debe contestar Todas las Preguntas"
returnvariable="MG_Advertencia_Debe_contestar_Todas"/> 


<cfset session.TotalPromedioAuto = 0>

<cfif isdefined('url.force') and len(trim(url.force))>
	<cfset form.chk = "#url.force#">
	<cfset form.Ecodigo = 3>
	<cfset url.TIPO = 'auto'>
</cfif>

<cfif not isdefined("form.Masiva")>
	<cfset form.Masiva='NO' >
</cfif>	

<!--- <cf_dump var="#form#"> --->

<!---- Funcion que me devuelve el resultado del cuestionario---->
<cffunction name="FuncObtieneResultado" returntype="string" output="true" access="private">			
	<cfargument name='PPCUreferencia'	type='numeric' 	required='yes'>	<!---RHEEid(PCUreferencia/Cod.de la evaluacion)---->
	<cfargument name='PDEid'			type='numeric' 	required='yes'>	<!---DEid(Cod. del evaluante)---->
	<cfargument name='PPCid'			type='numeric' 	required='yes'>	<!---PCid(Cod. del cuestionario)---->
	<cfargument name='PDEideval'	type='numeric' 	required='yes'>	<!---DEideval(Cod.del evaluador)---->
	<cfargument name='Conocimiento' type='boolean' 	required='yes' default="FALSE">
	<cfargument name='DEBUG' type='boolean' 	required='yes' default="false">	
	<!----Seleccion de la opcion seleccionada cuando es option button----->
	<cfquery name="rsDatos" datasource="#session.DSN#">
		select  a.PCUid,
				b.PCid,											<!-----id del cuestionario--->
				b.PPid,											<!-----id de la pregunta--->
				c.PRid,											<!-----id seleccionado en las respuestas--->
				coalesce(c.PRUvalor,0.00) as PRUvalor,			<!-----valor respuesta--->
				coalesce(d.PPvalor,0.00) as PPvalor				<!-----valor pregunta--->
				,d.PPtipo										<!-----tipo pregunta--->
				,(select coalesce(max(PRvalor),1) 				<!-----Valor mayor de las respuestas Osea el que significa el 100%--->
					from PortalRespuesta z
					where z.PCid = b.PCid
						and z.PPid = b.PPid
						and z.PRvalor is not null
				 ) as mayor,
				  (select sum(PRvalor)							<!-----Suma de todos los pesos de todas las posibles respuestas--->
					from PortalRespuesta x
					where x.PCid = b.PCid
						and x.PPid = b.PPid
						and x.PRvalor is not null
					group by x.PPid
					) as resptotal
		
					,d.PPparte
					,(select SUM(w.PRUvalor)/count(w.PRUvalor) from 
					PortalPregunta v
					inner join PortalRespuestaU w
					on w.PPid = v.PPid
					<!---and w.PCUid = a.PCUid--->
					where v.PCid = b.PCid
					and v.PPvalor != 0
					and w.PRUvalor > -1
					and v.PPparte=d.PPparte
					and w.PCUid = a.PCUid) as NotaXparte
		
				, coalesce( c.PRUvalor,0 ) as NOTAPREGUNTAA
		from PortalCuestionarioU a 
		
			inner join PortalPreguntaU b
				on a.PCUid = b.PCUid		
		
				inner join PortalPregunta d
					on b.PCid = d.PCid
					and b.PPid = d.PPid
					and d.PPvalor != 0
					and d.PPtipo != 'E'
		
			left outer join PortalRespuestaU c
				on b.PCUid = c.PCUid
				and b.PCid = c.PCid
				and b.PPid = c.PPid
				
		where a.PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PPCUreferencia#"><!----value="#vnDatos[2]#">---->
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PDEid#"><!---value="#vnDatos[1]#">---->
			and a.DEideval=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PDEideval#">
			and b.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.PPCid#">
			<cfif Arguments.Conocimiento eq FALSE>
			and coalesce(c.PRUvalor,0) >= 0
			</cfif>	
            and a.PCUid  = (select max(z.PCUid) from PortalCuestionarioU z
                        where a.DEid = z.DEid 
                        and a.DEideval  = z.DEideval 
                        and a.PCUreferencia = z.PCUreferencia  )
            
	</cfquery>
	
<!---	<cfdump var='#rsDatos#'>
	<cfabort>
--->	
	<!---Parche debido a que la nota de autoevaluacion no era correcta 
		<cfquery dbtype="query" name="rsPartesPromedios">
			select distinct PPparte, NotaXparte from rsDatos
		</cfquery>
		<cfset totalPartes = rsPartesPromedios.recordCount>
		<cfset session.TotalPromedioAuto = 0>
		<cfif totalPartes GT 0>
			<cfquery dbtype="query" name="rsPromedioTotal">
				select  SUM(NotaXparte)/#totalPartes# as dat from rsPartesPromedios
			</cfquery>
			<cfset session.TotalPromedioAuto = rsPromedioTotal.dat>
		</cfif>--->
	<!---Fin Parche--->
		
	
		<cfif Arguments.DEBUG eq TRUE>
			<cfdump  var="#Arguments#">
			<cfdump var="#rsDatos#">		
		</cfif>	
	
	<cfset vnCuestionario = 0.00>	<!---Sumatoria de todos los promedios de las preguntas--->	
	<cfset vnPCuestionario = 0><!---Suma de los promedios de las preguntas segun las respuestas del que lleno el cuestionario(promedio del cuestionario=NOTA)--->

	<cfif rsDatos.RecordCount NEQ 0>						
		<cfoutput query="rsDatos" group="PPid">		
			<cfset vnTempNota = 0><!---Variable con la sumatoria del porcentaje de las resp. de las preguntas--->
			<cfset vnPregunta = 0><!---Variable con el promedio por pregunta---->			
			<cfset vnPromedioR = 0><!---Variable con el promedio de las Todas las respuestas--->
			<!---Si la pregunta pertenece a una parte que solo una respuesta---->				
			<!---///////////////////////OPCION MULTIPLE////////////////////////////////////////////
				Cuando es opcion multiple obtener la suma de todos los pesos de todas las respuestas(rsDatos.resptotal),
				luego sumar los pesos de las respuestas seleccionadas en el cuestionario=checkeadas(Output agrupado por PRid).  
				Finalmente se promedia por regla de tres.
			////////////////////////////////////////////////////////////////////////////---->	
			<cfoutput group="PRid">
				<cfif rsDatos.PPtipo EQ 'M'>
					<cfset vnTempNota = vnTempNota + rsDatos.PRUvalor>
				<cfelse>
					<cfset vnTempNota = rsDatos.PRUvalor>
				</cfif>					
			</cfoutput>
			<cfif rsDatos.PPtipo EQ 'M'><!---Se promedian las notas cuando es multiple seleccion---->
				<cfif rsDatos.resptotal NEQ 0>
					<cfset vnPregunta = (vnTempNota*100)/rsDatos.resptotal><!----Promedio sobre el peso de la pregunta---->
					<cfset vnPromedioR = vnPregunta ><!---Promedio sobre el peso de la respuesta--->
				<cfelse>
					<cfset vnPromedioR = 0>
				</cfif>
			<!---///////////////////////SELECCION UNICA///////////////////////////////////////////
				Cuando es un option buton(seleccion unica) se promedia el valor de la respuesta seleccionada
				segun el puntaje mayor (EJ: Si las posibles respuestas son--> opt1:20,opt2:30,opt3:15 y se seleccionaron la 1 y 2
				se obtiene cuanto es 20 de 30(que es el mayor) y cuanto es 30 de 30 por regla de tres) y suma los promedios
			////////////////////////////////////////////////////////////////////////////---->					
			<cfelseif rsdatos.PPtipo EQ 'U'>					
				<cfif rsDatos.mayor NEQ 0>
					<cfset vnPregunta = rsDatos.PRUvalor*100/rsDatos.mayor><!---Promedio sobre el peso mayor--->
					<cfset vnPromedioR = (rsDatos.PPvalor*vnPregunta)/100><!---Promedio sobre el peso de la respuesta--->
				<cfelse>
					<cfset vnPromedioR = 0>
				</cfif>	
			<!---//////////////////////////CUALQUIER OTRO CASO/////////////////////////////////////
				En cualquier otro tipo de pregunta se la asigna el valor total de la pregunta(=cualquier respuesta esta bien!!)
			////////////////////////////////////////////////////////////////////////////---->
			<cfelseif rsdatos.PPtipo EQ 'V' or rsdatos.PPtipo EQ 'D' or rsdatos.PPtipo EQ 'O'>
				<!---<cfset vnPregunta = vnTempNota>--->
				<cfset vnPromedioR = rsDatos.PPvalor>
			</cfif>	
			<!----///////////////Variable donde se van sumando los promedios de  cada pregunta/////////////----->	
			<cfif Arguments.DEBUG eq TRUE>
				**<cfdump var="#vnPromedioR#"><br>
			</cfif>				
			<cfset vnCuestionario = vnCuestionario+vnPromedioR>				
		</cfoutput>	
		<cfif Arguments.DEBUG eq TRUE>
				***<cfdump var="#vnCuestionario#"><br>
		</cfif>		
		<!---////////////////////////////////NOTA FINAL/////////////////////////////////////
			Obtener la suma de todos los pesos de las preguntas del cuestionario
			para promediarlo con la suma de todos las respuestas (vnCuestionario) 
		////////////////////////////////////////////////////////////////////////////---->
		<cfquery name="rsPromedioP" dbtype="query">
			select sum(PPvalor) as PPvalor
			from rsDatos
		</cfquery>
		
		<cfif Arguments.DEBUG eq TRUE>
				****rsPromedioP<cfdump var="#rsPromedioP#"><br>
				*****<cfdump var="#vnPCuestionario#"><br>
		</cfif>
		
		<cfif isdefined("vnPCuestionario")>
			<cfset vnPCuestionario = (((vnCuestionario*100)/rsPromedioP.PPvalor))>
		<cfelse>
			<cfset vnPCuestionario = 0>
		</cfif>
	<cfelse>		
		<cfset vnPCuestionario = -1>
	</cfif>
	<cfif Arguments.DEBUG eq TRUE>
				*****vnPCuestionario<cfdump var="#vnPCuestionario#"><br>
				******vnCuestionario<cf_dump var="#vnCuestionario#"><br>
	</cfif>
	
	<cfreturn NumberFormat(vnPCuestionario,'999.999')><!---Retorno el resultado---->
</cffunction>

<!----Recorrer todos los cuestionarios segun la relacion de evaluacion---->

<cfset mensaje ="">
<cfset estatus ="1">

<cftransaction>	
	<cfloop list="#form.chk#" index="i"><!---1:DEid, 2:RHEEid, 3.RHPcodigo, 4:PCid , 6:estatus---->		
		<cfset vnDatos = ListToArray(i,'|')>	
		<cfset vnResultado = 0>
		<cfset form.RHEEid=vnDatos[2]>
        <cfif form.Masiva eq 'SI'>
        	<cfset form.PCid=vnDatos[4]>
            <cfset estatus=vnDatos[6]>
        </cfif>
        <cfif estatus  eq 1>
            <cfquery name="rs" datasource="#session.DSN#">
                select a.DEid,a.DEideval,a.Usucodigo,a.Usucodigoeval,b.PCid,a.PCUreferencia, b.PCUid
                from PortalCuestionarioU a
                    inner join PortalPreguntaU b
                        on a.PCUid = b.PCUid
                where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                    and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[5]#">
                    and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
            </cfquery>	

		
	<!------------------------------------------ VERIFICACION DE RESPUESTA COMPLETAS----------------------->
	
	 <cfquery name="rsV" datasource="#session.DSN#">
			SELECT distinct b.PCid,b.PCUid
			FROM PortalCuestionarioU a
				INNER JOIN PortalPreguntaU b
					on a.PCUid = b.PCUid
			WHERE DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
				AND DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[5]#">
				AND PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
				AND b.PCUid = (	SELECT MAX(a.PCUid)
									 		FROM PortalCuestionarioU a
										  		INNER JOIN PortalPreguntaU b
											  		on a.PCUid = b.PCUid
										   WHERE DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
													and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[5]#">
													and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">)
		</cfquery>
		
			
		<cfif rsV.RecordCount NEQ 0>

		<cfset faltan=0><!--- Guardará los errores posibles---->
		<cfset cantidadPregunta=0>
		<cfloop query="rsV">
		
			<cfquery name="data" datasource="#session.DSN#">
				select pc.PCid, pp.PPid, pp.PPtipo,pc.PCcodigo,pc.PCnombre,pp.PPnumero
				from PortalCuestionario pc
					inner join PortalPregunta pp
						on pc.PCid=pp.PCid
				where pc.PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCid#">
					    and pp.PPtipo != 'E'
				order by PPparte, PPnumero, PPtipo
			</cfquery>	
			<cfloop query="data">

				<cfset cantidadPregunta=cantidadPregunta+1>
				
				<cfif data.PPtipo eq 'U' ><!--- si la pregunta es de tipo seleccion unica--->
				
				<cfquery name="RespuestaTipoU" datasource="#session.DSN#">
					select 1 from PortalRespuestaU where 
					PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCUid#">
					and PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCid#">
					and PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PPid#">
				</cfquery>
						<cfif RespuestaTipoU.RecordCount EQ 0>
							<cfset faltan=faltan+1>
						</cfif>

				
				<cfelseif data.PPtipo eq 'M'><!--- si la pregunta es de seleccion multiple--->

				<cfquery name="RespuestaTipoM" datasource="#session.DSN#">
					select 1 from PortalRespuestaU where 
					PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCUid#">
					and PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCid#">
					and PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PPid#">
				</cfquery>
						<cfif RespuestaTipoM.RecordCount EQ 0>
							 <cfset faltan=faltan+1>
						</cfif>
				
				
				<cfelseif data.PPtipo eq 'D'><!--- si la pregunta es de tipo desarrollo--->
				
				<cfquery name="PreguntaTipoD" datasource="#session.DSN#">
						select PCUtexto from PortalPreguntaU 
						where PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCUid#">
						and PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCid#">
						and PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PPid#">
					</cfquery>
						<cfif PreguntaTipoD.RecordCount EQ 0>
								 <cfset faltan=faltan+1>
							
						<cfelse>
							<cfif len(trim(PreguntaTipoD.PCUtexto)) EQ 0>
								<cfset faltan=faltan+1>
						
							</cfif>
						</cfif>
									
				<cfelseif data.PPtipo eq 'O' ><!--- si la pregunta es de tipo ordenamiento--->

					<cfquery name="RespuestaTipoO" datasource="#session.DSN#">
						select 1 from PortalRespuestaU
						where
							PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCUid#">
							and PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCid#">
							and PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PPid#">
					</cfquery>
						<cfif RespuestaTipoO.RecordCount EQ 0><cfdump var="#RespuestaTipoO#">
							 <cfset faltan=faltan+1>
						</cfif>
						
						
				<cfelseif data.PPtipo eq 'V' ><!--- si la pregunta es de tipo valoracion--->

					<cfquery name="RespuestaTipoV" datasource="#session.DSN#">
						select 1 from PortalPreguntaU
						where
							PCUid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCUid#">
							and PCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCid#">
							and PPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PPid#">
					</cfquery>
						<cfif RespuestaTipoV.RecordCount EQ 0><cfdump var="#RespuestaTipoV#">
							 <cfset faltan=faltan+1>
						</cfif>		

				<cfelse><!--- si la pregunta es de tipo Etiqueta--->

						<cfquery name="RespuestaTipoELSE" datasource="#session.DSN#">
							select PCUtexto from  PortalPreguntaU
							where PCUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCUid#">
							  and PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsV.PCid#">
							  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PPid#">
						</cfquery>

						<cfif RespuestaTipoELSE.RecordCount EQ 0>
								 <cfset faltan=faltan+1>
							
						<cfelse>
							<cfif len(trim(RespuestaTipoELSE.PCUtexto)) EQ 0>
								 <cfset faltan=faltan+1>
								
							</cfif>
						</cfif><!---354--->
			</cfif><!---342--->
			</cfloop><!--- cfloop data 269--->
			<!---</cfoutput> fin del ciclo de cfoutput--->
			</cfloop><!--- fin del loop de PortalCuestionario--->

				<cfif  faltan NEQ 0>
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errTitle=#MG_Advertencia_Debe_contestar_Todas#&ErrDet=<br> #MG_Preguntas_No_se_han_contestado# <b>#faltan#</b> #MG_De#<b>#cantidadPregunta#</b> #MG_Preguntas#" addtoken="no">
					<cfabort>
				</cfif>
			</cfif>	

			<!-------------------------------------- FIN DE COMPROBACION RESPUESTAS COMPLETAS ------------------------------------->
            
			<cfif rs.RecordCount NEQ 0>
				<cfif  vnDatos[4] LTE 0> <!---SI ES POR HABILIDADES, CONOCIMIENTOS O HABILIDADES Y CONOCIMIENTOS DEL PUESTO 0 POR CONOCIMIENTOS, -1 POR HABILIDADES, -2 POR HABILIDADES Y CONOCIMIENTOS ---->
					<!---Para c/habilidad inserto registro con la nota del cuestionario--->			
					<cfquery datasource="#session.DSN#">
						delete RHDEvaluacionDes
						where RHEEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
						and DEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
						and DEideval    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.DEideval#">
					</cfquery>
					<cfquery datasource="#session.DSN#" >
						update RHNotasEvalDes
                        set RHNEDnotaauto=-1, 
	                        RHNEDnotajefe=-1,
                            RHNEDpromotros=-1,
                            RHNEDpromJCS=-1,
                            RHNEDpesoDist=-1
						where RHEEid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
						and DEid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
					</cfquery>
                    
					<cfif vnDatos[4] LT 0>
						<!---Traigo las habilidades de ese puesto--->
						<cfquery name="rsHabilidad" datasource="#session.DSN#">
							select RHHid,
								   PCid 
							from RHHabilidadesPuesto
							where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vnDatos[3]#">
								and PCid is not null
						</cfquery>
                        
						<cfloop query="rsHabilidad">												
							<cfset vnDEideval = vnDatos[5]>
							<cfset vnResultado = FuncObtieneResultado(vnDatos[2],vnDatos[1],rsHabilidad.PCid,vnDEideval)>									
							<!---Inserta los resultados por habilidad---->							
							<cfquery datasource="#session.DSN#" name="insert">
								insert into RHDEvaluacionDes(RHEEid,DEid,DEideval,RHHid,RHCid,RHDEnota,RHDEporcentaje,RHDEfecha,BMUsucodigo)
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.DEideval#">,
										<cfif isdefined("rsHabilidad") and len(trim(rsHabilidad.RHHid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHabilidad.RHHid#"><cfelse>null</cfif>,
										null,
										<cfif isdefined("vnResultado") and len(trim(vnResultado))><cfqueryparam cfsqltype="cf_sql_varchar"  value="#vnResultado#"><cfelse>null</cfif>,
										<cfif isdefined("vnResultado") and len(trim(vnResultado))><cfqueryparam cfsqltype="cf_sql_numeric" value="#vnResultado#"><cfelse>null</cfif>,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								)						
							</cfquery>
						</cfloop>

<!--- LZ. 20140909- Inclusion de los Cuestiones por Conocimiento --->                        
						<cfquery name="rsConocimientos" datasource="#session.DSN#">
							select RHCid,
								   PCid 
							from RHConocimientosPuesto
							where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vnDatos[3]#">
								and PCid is not null
						</cfquery>
						<cfloop query="rsConocimientos">												
							<cfset vnDEideval = vnDatos[5]>
							<cfset vnResultado = FuncObtieneResultado(vnDatos[2],vnDatos[1],rsConocimientos.PCid,vnDEideval)>									
							<!---Inserta los resultados por habilidad---->							
							<cfquery datasource="#session.DSN#" name="insert">
								insert into RHDEvaluacionDes(RHEEid,DEid,DEideval,RHHid,RHCid,RHDEnota,RHDEporcentaje,RHDEfecha,BMUsucodigo)
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.DEideval#">,
										null,
										<cfif isdefined("rsConocimientos") and len(trim(rsConocimientos.RHCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConocimientos.RHCid#"><cfelse>null</cfif>,                                        
										<cfif isdefined("vnResultado") and len(trim(vnResultado))><cfqueryparam cfsqltype="cf_sql_varchar"  value="#vnResultado#"><cfelse>null</cfif>,
										<cfif isdefined("vnResultado") and len(trim(vnResultado))><cfqueryparam cfsqltype="cf_sql_numeric" value="#vnResultado#"><cfelse>null</cfif>,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								)						
							</cfquery>
						</cfloop>

                        
						<!---Actualiza la nota de AUTOEVALUACION ---->
						<!--- HABILIDADES --->
						<cfquery name="rsAuto" datasource="#session.DSN#">
							update RHNotasEvalDes
								set RHNEDnotaauto = <cf_dbfunction name="to_float" args="
													(select (a.RHDEnota )
													from RHNotasEvalDes c
													inner join RHDEvaluacionDes a
														on c.RHEEid = a.RHEEid
														and c.DEid = a.DEid
														and c.RHHid = a.RHHid
													inner join RHEvaluadoresDes b
														on a.RHEEid = b.RHEEid
														and a.DEid=b.DEid
														and a.DEideval=b.DEideval
													where a.RHEEid = #vnDatos[2]#
														and a.DEid = #vnDatos[1]#
														and b.RHEDtipo = 'A'
														and c.RHHid = RHNotasEvalDes.RHHid 
														)">
							where exists (
								select 1 
								from RHNotasEvalDes c
								inner join RHDEvaluacionDes a
									on c.RHEEid = a.RHEEid
									and c.DEid = a.DEid
									and c.RHHid = a.RHHid
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
								where a.RHEEid = #vnDatos[2]#
									and a.DEid = #vnDatos[1]#
									and b.RHEDtipo = 'A'
									and c.RHHid = RHNotasEvalDes.RHHid 
							)
							and RHNotasEvalDes.RHEEid = #vnDatos[2]#
							and RHNotasEvalDes.DEid = #vnDatos[1]#
						</cfquery>
                        
                        
<!--- LZ. 20140909- Inclusion de los Cuestiones por Conocimiento --->                             

						<!---Actualiza la nota de AUTOEVALUACION ---->
						<!--- CONOCIMIENTOS --->
						<cfquery name="rsAuto" datasource="#session.DSN#">
							update RHNotasEvalDes
								set RHNEDnotaauto = <cf_dbfunction name="to_float" args="
													(select (a.RHDEnota )
													from RHNotasEvalDes c
													inner join RHDEvaluacionDes a
														on c.RHEEid = a.RHEEid
														and c.DEid = a.DEid
														and c.RHCid = a.RHCid
													inner join RHEvaluadoresDes b
														on a.RHEEid = b.RHEEid
														and a.DEid=b.DEid
														and a.DEideval=b.DEideval
													where a.RHEEid = #vnDatos[2]#
														and a.DEid = #vnDatos[1]#
														and b.RHEDtipo = 'A'
														and c.RHCid = RHNotasEvalDes.RHCid 
														)">
							where exists (
								select 1 
								from RHNotasEvalDes c
								inner join RHDEvaluacionDes a
									on c.RHEEid = a.RHEEid
									and c.DEid = a.DEid
									and c.RHCid = a.RHCid
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
								where a.RHEEid = #vnDatos[2]#
									and a.DEid = #vnDatos[1]#
									and b.RHEDtipo = 'A'
									and c.RHCid = RHNotasEvalDes.RHCid 
							)
							and RHNotasEvalDes.RHEEid = #vnDatos[2]#
							and RHNotasEvalDes.DEid = #vnDatos[1]#
						</cfquery>           
						
						<!---========= Actualiza la nota del jefe ======---->
						<!--- HABILIDADES --->
						<cfquery name="rsJefe" datasource="#session.DSN#">
							update RHNotasEvalDes
								set RHNEDnotajefe = <cf_dbfunction name="to_float" args="
													(select (a.RHDEnota)
													from RHNotasEvalDes c
													inner join RHDEvaluacionDes a
														on c.RHEEid = a.RHEEid
														and c.DEid = a.DEid
														and c.RHHid = a.RHHid
													inner join RHEvaluadoresDes b
														on a.RHEEid = b.RHEEid
														and a.DEid=b.DEid
														and a.DEideval=b.DEideval
													where a.RHEEid = #vnDatos[2]#
														and a.DEid = #vnDatos[1]#
														and b.RHEDtipo  in ('J', 'E') 
														and c.RHHid = RHNotasEvalDes.RHHid
														)">
							where exists (
								select 1 
								from RHNotasEvalDes c
								inner join RHDEvaluacionDes a
									on c.RHEEid = a.RHEEid
									and c.DEid = a.DEid
									and c.RHHid = a.RHHid
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
								where a.RHEEid = #vnDatos[2]#
									and a.DEid = #vnDatos[1]#
									and b.RHEDtipo  in ('J', 'E') 
									and c.RHHid = RHNotasEvalDes.RHHid
							)
							and RHNotasEvalDes.RHEEid = #vnDatos[2]#
							and RHNotasEvalDes.DEid = #vnDatos[1]#
						</cfquery>
                        
<!--- LZ. 20140909- Inclusion de los Cuestiones por Conocimiento --->   
	<!---========= Actualiza la nota del jefe ======---->
						<!--- CONOCIMIENTOS --->
						<cfquery name="rsJefe" datasource="#session.DSN#">
							update RHNotasEvalDes
								set RHNEDnotajefe = <cf_dbfunction name="to_float" args="
													(select (a.RHDEnota)
													from RHNotasEvalDes c
													inner join RHDEvaluacionDes a
														on c.RHEEid = a.RHEEid
														and c.DEid = a.DEid
														and c.RHCid = a.RHCid
													inner join RHEvaluadoresDes b
														on a.RHEEid = b.RHEEid
														and a.DEid=b.DEid
														and a.DEideval=b.DEideval
													where a.RHEEid = #vnDatos[2]#
														and a.DEid = #vnDatos[1]#
														and b.RHEDtipo  in ('J', 'E') 
														and c.RHCid = RHNotasEvalDes.RHCid
														)">
							where exists (
								select 1 
								from RHNotasEvalDes c
								inner join RHDEvaluacionDes a
									on c.RHEEid = a.RHEEid
									and c.DEid = a.DEid
									and c.RHCid = a.RHCid
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
								where a.RHEEid = #vnDatos[2]#
									and a.DEid = #vnDatos[1]#
									and b.RHEDtipo  in ('J', 'E') 
									and c.RHCid = RHNotasEvalDes.RHCid
							)
							and RHNotasEvalDes.RHEEid = #vnDatos[2]#
							and RHNotasEvalDes.DEid = #vnDatos[1]#
						</cfquery>

                        
						<!---======== Actualiza RHNotasEvalDes con el promedio de las notas de otros evaluadores ========---->
						<cfquery name="rsOtros" datasource="#session.DSN#"><!---Obtiene el promedio de la suma de todas las notas / las personas que hasta el momento han evaluado ---->					
							select 	a.RHHid, 		
									<!--- coalesce(sum(convert(float,RHDEnota)),0) as Notas, --->
									coalesce(sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then <cf_dbfunction name="to_float" args="RHDEnota"> else 0  end),0) as Notas,
									case sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then 1 else 0 end) when 0 then 1
									else sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then 1 else 0 end) end as Evaluadores
							from RHDEvaluacionDes a
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
							where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
								and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
								and b.RHEDtipo in ('C', 'S')
								and a.RHHid is not null
							group by a.RHHid
						</cfquery>
                        
						<cfloop query="rsOtros">
							<cfquery name="rsOtros2" datasource="#session.DSN#">
								update RHNotasEvalDes
									set RHNEDpromotros = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsOtros.Notas/rsOtros.Evaluadores#">
								where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
									and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
									and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOtros.RHHid#">
							</cfquery>
						</cfloop>	
                        

<!--- LZ. 20140909- Inclusion de los Cuestiones por Conocimiento --->     
						<!---======== Actualiza RHNotasEvalDes con el promedio de las notas de otros evaluadores ========---->
						<cfquery name="rsOtrosC" datasource="#session.DSN#"><!---Obtiene el promedio de la suma de todas las notas / las personas que hasta el momento han evaluado ---->					
							select 	a.RHCid, 		
									<!--- coalesce(sum(convert(float,RHDEnota)),0) as Notas, --->
									coalesce(sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then <cf_dbfunction name="to_float" args="RHDEnota"> else 0  end),0) as Notas,
									case sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then 1 else 0 end) when 0 then 1
									else sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then 1 else 0 end) end as Evaluadores
							from RHDEvaluacionDes a
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
							where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
								and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
								and b.RHEDtipo in ('C', 'S')
								and a.RHCid is not null
							group by a.RHCid
						</cfquery>
                        
						<cfloop query="rsOtrosC">
							<cfquery name="rsOtros2C" datasource="#session.DSN#">
								update RHNotasEvalDes
									set RHNEDpromotros = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsOtrosC.Notas/rsOtrosC.Evaluadores#">
								where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
									and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
									and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsOtrosC.RHCid#">
							</cfquery>
						</cfloop>	
                      
                        
						<!--- GENERA NOTA DE JEFE-COMPAÑEROS-SURORDINADOS --->
						<!---Obtiene el promedio de la suma de todas las notas / las personas que hasta el momento han evaluado 
							cuando son mayores o igual a 0, esto para el caso que no se quiera contestar ()NA---->					
						<cfquery name="rsJCS" datasource="#session.DSN#">
							select 	a.RHHid, 		
									coalesce(sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then <cf_dbfunction name="to_float" args="RHDEnota"> else -1  end),-1) as Notas,
									case sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then 1 else -1 end) when 0 then 1
									else sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then 1 else -1 end) end as Evaluadores
							from RHDEvaluacionDes a
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
							where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
								and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
								and b.RHEDtipo in ('C', 'S','J','E')
								and a.RHHid is not  null
							group by a.RHHid
						</cfquery>
                        

						<cfloop query="rsJCS">
							<cfquery name="rsJCS2" datasource="#session.DSN#">
								update RHNotasEvalDes
									set RHNEDpromJCS = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsJCS.Notas/rsJCS.Evaluadores#">
								where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
									and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
									and RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJCS.RHHid#">
							</cfquery>
						</cfloop>	


                        
                        
<!--- LZ. 20140909- Inclusion de los Cuestiones por Conocimiento --->  
						<!--- GENERA NOTA DE JEFE-COMPAÑEROS-SURORDINADOS --->
						<!---Obtiene el promedio de la suma de todas las notas / las personas que hasta el momento han evaluado 
							cuando son mayores o igual a 0, esto para el caso que no se quiera contestar ()NA---->					
						<cfquery name="rsJCSC" datasource="#session.DSN#">
							select 	a.RHCid, 		
									coalesce(sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then <cf_dbfunction name="to_float" args="RHDEnota"> else -1  end),-1) as Notas,
									case sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then 1 else -1 end) when 0 then 1
									else sum(case when <cf_dbfunction name="to_float" args="RHDEnota"> >= 0 then 1 else -1 end) end as Evaluadores
							from RHDEvaluacionDes a
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
							where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
								and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
								and b.RHEDtipo in ('C', 'S','J','E')
								and a.RHCid is not  null
							group by a.RHCid
						</cfquery>

						<cfloop query="rsJCSC">
							<cfquery name="rsJCS2C" datasource="#session.DSN#">
								update RHNotasEvalDes
									set RHNEDpromJCS = <cfif #rsJCSC.Notas# gt -1 >
                                    						<cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsJCSC.Notas/rsJCSC.Evaluadores#">
                                                       <cfelse>
                                                       		-1
                                                       </cfif>
								where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
									and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
									and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsJCSC.RHCid#">
							</cfquery>
						</cfloop>	


						<!--- 	SUMA DE PESOS --->
						<!--- 	SE HACE LA SUMA DE LOS PESOS PARA CADA UNA DE LAS NOTAS XQ PUEDE SER QUE NO SE CALIFIQUE EN ALGUNA
								Y PUEDA DAR ERROR EN EL CALCULO DE LA NOTA --->
						<!--- 	SUMA DE PESOS DE CUESTIONARIOS DE JEFE --->
		
		
						<!---verifica si existe preguntas con nota -1 para distribuir su peso en los demás ---->
						
						<!--- SUMA DE PESOS DE CUESTIONARIOS DE AUTOEVALUACION --->
	
						<cfquery name="rsPPDistribuir" datasource="#session.DSN#">
							select  sum(RHNEDpeso)  as RHNEDpeso  
							from RHNotasEvalDes
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDnotaauto  is not null
							and RHNEDnotaauto  > -1
						</cfquery>
                        
						<cfquery name="rstodospesos" datasource="#session.DSN#">
							select  sum(RHNEDpeso)  as RHNEDpeso  
							from RHNotasEvalDes
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDnotaauto  is not null
							and RHNEDnotaauto  > -1                            
						</cfquery>

						<cfquery name="RSupdate" datasource="#session.DSN#">
							update RHNotasEvalDes 
							<cfif  isdefined("rsPPDistribuir") and isdefined("rstodospesos") and  rstodospesos.RHNEDpeso  eq rsPPDistribuir.RHNEDpeso>
								set RHNEDpesoDist = RHNEDpeso
							<cfelse>
								set RHNEDpesoDist = (RHNEDpeso / #rsPPDistribuir.RHNEDpeso#)*100
							</cfif>
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDnotaauto  is not null
							and RHNEDnotaauto  > -1
						</cfquery>

                        
						
						<cfquery name="rsPesoA" datasource="#session.DSN#">
							select 	coalesce(sum(RHNEDpesoDist),1)	as peso
							from RHNotasEvalDes 
							where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							  and RHNEDnotaauto is not null
							  and RHNEDnotaauto > -1
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
						</cfquery>
	
						<cfif  isdefined("rsPesoA") and rsPesoA.RecordCount ><cfset Lvar_Pauto  = rsPesoA.peso><cfelse><cfset Lvar_Pauto  = 1></cfif>
						<cfif Lvar_Pauto  eq 0><cfset Lvar_Pauto  = 1></cfif>
						
						<cfquery name="rsPromedioFinalA" datasource="#session.DSN#">
							select 	
							(coalesce(sum(RHNEDnotaauto*RHNEDpesoDist),0) / #Lvar_Pauto#) as RHNEDnotaauto
							 from RHNotasEvalDes a
							where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDnotaauto is not null
							and RHNEDnotaauto > -1
						</cfquery>

						<!--- SUMA DE PESOS DE CUESTIONARIOS DE OTROS --->
	
						<!---verifica si existe preguntas con nota -1 para distribuir su peso en los demás ---->
						<cfquery name="rsPPDistribuir" datasource="#session.DSN#">
							select  sum(RHNEDpeso)  as RHNEDpeso  
							from RHNotasEvalDes
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDpromotros  is not null
							and RHNEDpromotros  > -1
						</cfquery>
	
						<cfquery name="rstodospesos" datasource="#session.DSN#">
							select  sum(RHNEDpeso)  as RHNEDpeso  
							from RHNotasEvalDes
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDpromotros  is not null
							and RHNEDpromotros  > -1                            
						</cfquery>
	
						<cfquery name="RSupdate" datasource="#session.DSN#">
							update RHNotasEvalDes
							<cfif  isdefined("rsPPDistribuir") and isdefined("rstodospesos") and  rstodospesos.RHNEDpeso  eq rsPPDistribuir.RHNEDpeso>
								set RHNEDpesoDist = RHNEDpeso
							<cfelse>
								set RHNEDpesoDist = (RHNEDpeso / #rsPPDistribuir.RHNEDpeso#)*100
							</cfif>
					
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDpromotros  is not null
							and RHNEDpromotros  > -1
						</cfquery>
					   
					   <cfquery name="rsPesoO" datasource="#session.DSN#">
							select coalesce(sum(RHNEDpesoDist),1)	as peso
							from RHNotasEvalDes 
							where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							  and RHNEDpromotros is not null
							  and RHNEDpromotros > -1
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
						</cfquery>
						
						<cfif  isdefined("rsPesoO") and rsPesoO.RecordCount ><cfset Lvar_Potros  = rsPesoO.peso><cfelse><cfset Lvar_Potros  = 1></cfif>
						<cfif Lvar_Potros  eq 0><cfset Lvar_Potros  = 1></cfif>
						
						<cfquery name="rsPromedioFinalO" datasource="#session.DSN#">
							select 	
							(coalesce(sum(RHNEDpromotros*RHNEDpesoDist),0) / #Lvar_Potros#) as RHNEDpromotros
							 from RHNotasEvalDes a
							where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDpromotros is not null
							and RHNEDpromotros > -1
						</cfquery>
						
						
						<!--- SUMA DE PESOS DE CUESTIONARIOS DE RHNEDpromJCS --->
						
						<cfquery name="rsPPDistribuir" datasource="#session.DSN#">
							select  sum(RHNEDpeso)  as RHNEDpeso  
							from RHNotasEvalDes
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDpromJCS  is not null
							and RHNEDpromJCS  > -1
						</cfquery>
						
						<cfquery name="rstodospesos" datasource="#session.DSN#">
							select  sum(RHNEDpeso)  as RHNEDpeso  
							from RHNotasEvalDes
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDpromJCS  is not null
							and RHNEDpromJCS  > -1                            
						</cfquery>
                        
                        
	
						<cfquery name="RSupdate" datasource="#session.DSN#">
							update RHNotasEvalDes							 
							<cfif  isdefined("rsPPDistribuir") and isdefined("rstodospesos") and  rstodospesos.RHNEDpeso  eq rsPPDistribuir.RHNEDpeso>
								set RHNEDpesoDist = RHNEDpeso
							<cfelse>
								set RHNEDpesoDist = (RHNEDpeso / #rsPPDistribuir.RHNEDpeso#)*100
							</cfif>
					
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDpromJCS  is not null
							and RHNEDpromJCS  > -1
						</cfquery>
						
						<cfquery name="rsPesoP" datasource="#session.DSN#">
							select coalesce(sum(RHNEDpesoDist),1)	as peso
							from RHNotasEvalDes 
							where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							  and RHNEDpromJCS is not null
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
						</cfquery>
						
						<cfif  isdefined("rsPesoP") and rsPesoP.RecordCount ><cfset Lvar_Pjcs  = rsPesoP.peso><cfelse><cfset Lvar_Pjcs  = 1></cfif>
						<cfif Lvar_Pjcs  eq 0><cfset Lvar_Pjcs  = 1></cfif>
						
						<cfquery name="rsPromedioFinalJCS" datasource="#session.DSN#">
							select 	
							(coalesce(sum(RHNEDpromJCS*RHNEDpesoDist),0) / #Lvar_Pjcs#) as RHNEDpromJCS
							 from RHNotasEvalDes a
							where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDpromJCS  is not null
							and RHNEDpromJCS  > -1
						</cfquery>
						
						<!--- SUMA DE PESOS DE CUESTIONARIOS DE jefe --->
						
						<cfquery name="rsPPDistribuir" datasource="#session.DSN#">
							select  sum(RHNEDpeso)  as RHNEDpeso  
							from RHNotasEvalDes
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDnotajefe  is not null
							and RHNEDnotajefe  > -1
						</cfquery>
						
						<cfquery name="rstodospesos" datasource="#session.DSN#">
							select  sum(RHNEDpeso)  as RHNEDpeso  
							from RHNotasEvalDes
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDnotajefe  is not null
							and RHNEDnotajefe  > -1                            
						</cfquery>

						<cfquery name="RSupdate" datasource="#session.DSN#">
							update RHNotasEvalDes 
							<cfif  isdefined("rsPPDistribuir") and isdefined("rstodospesos") and  rstodospesos.RHNEDpeso  eq rsPPDistribuir.RHNEDpeso>
								set RHNEDpesoDist = RHNEDpeso
							<cfelse>
								set RHNEDpesoDist = (RHNEDpeso / #rsPPDistribuir.RHNEDpeso#)*100
							</cfif>
	
							where RHEEid          =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">          
							and DEid   			  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDnotajefe  is not null
							and RHNEDnotajefe  > -1
						</cfquery>


						<cfquery name="rsPesoJ" datasource="#session.DSN#">
							select coalesce(sum(RHNEDpesoDist),1)	as peso
							from RHNotasEvalDes 
							where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							  and RHNEDnotajefe is not null
							  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                              and RHNEDnotajefe  > -1
						</cfquery>
						<cfif  isdefined("rsPesoJ") and rsPesoJ.RecordCount >
							<cfset Lvar_PJefe  = rsPesoJ.peso>
						<cfelse>
							<cfset Lvar_PJefe  = 1>
						</cfif>
						<cfif Lvar_PJefe  eq 0>
							<cfset Lvar_PJefe  = 1>
						</cfif>
						
                        
						<cfquery name="rsPromedioFinalJ" datasource="#session.DSN#">
							select 	sum(RHNEDnotajefe) as sumnota,sum(RHNEDpesoDist) as sumpeso, #Lvar_PJefe# as jefe,
							(coalesce(sum(RHNEDnotajefe*RHNEDpesoDist),0) / #Lvar_PJefe#) as RHNEDnotajefe
							 from RHNotasEvalDes a
							where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							and RHNEDnotajefe  is not null
							and RHNEDnotajefe  > -1
						</cfquery>
                        
 <!---                       <cfdump var="#rsPesoJ#"><BR>
                        <cfdump var="#Lvar_PJefe#"><BR>
                        <cf_dump var="#rsPromedioFinalJ#"><BR>          --->              
                        


                        

			
						<!--- ***************************************************************************************** --->
		
						<!---Actualiza el promedio final---->
				
						<cfquery datasource="#session.DSN#">
							update RHListaEvalDes
							set RHLEnotajefe = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsPromedioFinalJ.RHNEDnotajefe#">,
								RHLEnotaauto = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsPromedioFinalA.RHNEDnotaauto#">,
								RHLEpromotros = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsPromedioFinalO.RHNEDpromotros#">,
								RHLEpromJCS = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#rsPromedioFinalJCS.RHNEDpromJCS#">
							where  RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
								and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">					
						</cfquery>
                        

						<cfquery name="rsPromedioFinal" datasource="#session.DSN#">
							select RHLEnotajefe
								,RHLEnotaauto
								,RHLEpromotros
								,RHLEpromJCS
							from RHListaEvalDes
							where  RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
							and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
						</cfquery>
					</cfif>
                     
					<!--- SI ES POR CONOCIMIENTOS --->
					<cfif  vnDatos[4] EQ 0 or vnDatos[4] EQ -2> <!---0 POR CONOCIMIENTOS, -1 POR HABILIDADES, -2 POR HABILIDADES Y CONOCIMIENTOS ---->
						<!---Traigo las habilidades de ese puesto--->
						<cfquery name="rsConocimiento" datasource="#session.DSN#">
							select a.RHCid, coalesce(a.PCid,b.PCid) as  PCid from 
							RHConocimientosPuesto  a
							inner  join RHConocimientos b
								on a.RHCid = b.RHCid
							where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#vnDatos[3]#">
							and 	coalesce(a.PCid,b.PCid) is not null								
						</cfquery>
						
						<!--- <cf_dump var="#rsConocimiento#">--->
<!--------------------------------------------------  CONOCIMIENTOS ------------------------------------------------------------------>
						<cfloop query="rsConocimiento">												
							<cfset vnDEideval = vnDatos[5]>
							<cfset vnResultado = FuncObtieneResultado(vnDatos[2],vnDatos[1],rsConocimiento.PCid,vnDEideval,TRUE)>
								
															
							<!---Inserta los resultados por conocimiento---->							
							<cfquery datasource="#session.DSN#" name="insert">
								insert into RHDEvaluacionDes(RHEEid,DEid,DEideval,RHHid,RHCid,RHDEnota,RHDEporcentaje,RHDEfecha,BMUsucodigo)
								values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.DEideval#">,
										null,
										<cfif isdefined("rsConocimiento") and len(trim(rsConocimiento.RHCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConocimiento.RHCid#"><cfelse>null</cfif>,
										<cfif isdefined("vnResultado") and len(trim(vnResultado))><cfqueryparam cfsqltype="cf_sql_varchar"  value="#vnResultado#"><cfelse>null</cfif>,
										<cfif isdefined("vnResultado") and len(trim(vnResultado))><cfqueryparam cfsqltype="cf_sql_numeric" value="#vnResultado#"><cfelse>null</cfif>,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
								)						
							</cfquery>
						</cfloop>	
									
						<!---Actualiza la nota de AUTOEVALUACION ---->
						<cfquery name="rsAuto" datasource="#session.DSN#">
							update RHNotasEvalDes
								set RHNEDnotaauto = <cf_dbfunction name="to_float" args="
													(select max(a.RHDEnota )
													from RHNotasEvalDes c
													inner join RHDEvaluacionDes a
														on c.RHEEid = a.RHEEid
														and c.DEid = a.DEid
														and c.RHCid = a.RHCid
													inner join RHEvaluadoresDes b
														on a.RHEEid = b.RHEEid
														and a.DEid=b.DEid
														and a.DEideval=b.DEideval
													where a.RHEEid = #vnDatos[2]#
														and a.DEid = #vnDatos[1]#
														and b.RHEDtipo = 'A'
														and c.RHCid = RHNotasEvalDes.RHCid
														)">
							where exists (
								select 1 
								from RHNotasEvalDes c
								inner join RHDEvaluacionDes a
									on c.RHEEid = a.RHEEid
									and c.DEid = a.DEid
									and c.RHCid = a.RHCid
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
								where a.RHEEid = #vnDatos[2]#
									and a.DEid = #vnDatos[1]#
									and b.RHEDtipo = 'A'
									and c.RHCid = RHNotasEvalDes.RHCid
							)
							and RHNotasEvalDes.RHEEid = #vnDatos[2]#
							and RHNotasEvalDes.DEid = #vnDatos[1]#
						</cfquery>						
						<cfquery name="rsNotas" datasource="#session.DSN#">
						select RHNEDnotaauto
							from 	RHNotasEvalDes
							where exists (
								select 1 
								from RHNotasEvalDes c
								inner join RHDEvaluacionDes a
									on c.RHEEid = a.RHEEid
									and c.DEid = a.DEid
									and c.RHCid = a.RHCid
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
								where a.RHEEid = #vnDatos[2]#
									and a.DEid = #vnDatos[1]#
									and b.RHEDtipo = 'A'
									and c.RHCid = RHNotasEvalDes.RHCid
									
							)
							and RHNotasEvalDes.RHEEid = #vnDatos[2]#
							and RHNotasEvalDes.DEid = #vnDatos[1]#
						</cfquery>
-						<!---========= Actualiza la nota del jefe ======---->
						<cfquery name="rsJefe" datasource="#session.DSN#">
							update RHNotasEvalDes
								set RHNEDnotajefe = <cf_dbfunction name="to_float" args="
													(select max(a.RHDEnota )
													from RHNotasEvalDes c
													inner join RHDEvaluacionDes a
														on c.RHEEid = a.RHEEid
														and c.DEid = a.DEid
														and c.RHCid = a.RHCid
													inner join RHEvaluadoresDes b
														on a.RHEEid = b.RHEEid
														and a.DEid=b.DEid
														and a.DEideval=b.DEideval
													where a.RHEEid = #vnDatos[2]#
														and a.DEid = #vnDatos[1]#
														and b.RHEDtipo  in ('J', 'E') 
														and c.RHCid = RHNotasEvalDes.RHCid
														)">
							where exists (
								select 1 
								from RHNotasEvalDes c
								inner join RHDEvaluacionDes a
									on c.RHEEid = a.RHEEid
									and c.DEid = a.DEid
									and c.RHCid = a.RHCid
								inner join RHEvaluadoresDes b
									on a.RHEEid = b.RHEEid
									and a.DEid=b.DEid
									and a.DEideval=b.DEideval
								where a.RHEEid = #vnDatos[2]#
									and a.DEid = #vnDatos[1]#
									and b.RHEDtipo   in ('J', 'E') 
									and c.RHCid = RHNotasEvalDes.RHCid
							)
							and RHNotasEvalDes.RHEEid = #vnDatos[2]#
							and RHNotasEvalDes.DEid = #vnDatos[1]#
						</cfquery>
					
<!---------------------------------------- FIN DE CONOCIMIENTOS   -------------------------------------------------------->						
						
					</cfif> 
                <cfelse><!---SI ES POR CUESTIONARIO ESPECIFICO--->				
                    <cfset vnResultado = 0>
										<cfset vnResultadoOtros = 0>
										<cfset OtrosEvaluadores = "">
						
						   			<cfset vnResultadoT = 0>
										<cfset vnResultadoTodos = 0>
										<cfset TodosEvaluadores = "">

                    <cfset vnDEideval = vnDatos[5]>
					
                    <cfset vnResultado = FuncObtieneResultado(vnDatos[2],vnDatos[1],vnDatos[4],vnDEideval)>
					
                    <!---<cfset vnResultado = session.TotalPromedioAuto>--->
                    <cfif rs.DEid EQ rs.DEideval><!---Si es una autoevaluacion--->
                        <cfquery datasource="#session.DSN#">
                            update RHListaEvalDes
                            set RHLEnotaauto = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#vnResultado#">
                            where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
                                and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                        </cfquery>
                    <cfelse><!---Si son evaluadores(no autoevaluacion)--->					
                        <cfquery name="rsOtros" datasource="#session.DSN#">
                            select RHEDtipo				 
                            from RHEvaluadoresDes
                            where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
                                and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                                and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[5]#">					
                        </cfquery>
						
    
                        <cfif rsOtros.RHEDtipo EQ 'J'><!----Si el evaluador es jefe---->
						
                            <cfquery datasource="#session.DSN#">
                                update RHListaEvalDes
                                set RHLEnotajefe = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#vnResultado#">
                                where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
                                    and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                            </cfquery>
							
                        <cfelseif rsOtros.RHEDtipo EQ 'C' or rsOtros.RHEDtipo EQ 'S'><!---Si el evaluador es compañero--->
                        
							 <cfquery name="rsOtrosT" datasource="#session.DSN#">
								select DEideval				 
								from RHEvaluadoresDes a
								where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
									and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
									and a.RHEDtipo in ('C','S')
									and a.RHEEid in (	select PCUreferencia 
										from PortalCuestionarioU pcu
										where pcu.PCUestado=10
										and pcu.PCUreferencia = a.RHEEid
										and pcu.DEid = a.DEid
								)	
	                        </cfquery>
							
					<!---	Entro al loop<cfdump var="#vnResultadoOtros#"></br>--->
							<cfif rsOtrosT.recordCount GT 0>
								<cfloop query="rsOtrosT">
									<cfset OtrosEvaluadores = rsOtrosT.DEideval >
									<!---<cfdump var="#OtrosEvaluadores#"></br>--->
									<cfset vnResultadoOtros = vnResultadoOtros + FuncObtieneResultado(vnDatos[2],vnDatos[1],vnDatos[4],OtrosEvaluadores)>	
									<!---<cfdump var="#vnResultadoOtros#"></br>--->
								</cfloop>
							</cfif>
					<!---		Antes
							divisor<cfdump var="#rsOtrosT.recordCount#"></br>
							resultado<cfdump var="#vnResultado#"></br>
							otros<cfdump var="#vnResultadoOtros#"></br>--->
							<cfset  vnResultado  =  (vnResultadoOtros) / ( iif(rsOtrosT.recordCount gt 0,rsOtrosT.recordCount,1))>
							<!---Asi estaba antes
							<cfset  vnResultado  =  (vnResultado + vnResultadoOtros) / ( rsOtrosT.recordCount + 1)>
							Creo que esta malo xq:
							vnResultadoOtros procesa todos los resultados al sumar vnResultado esta sumando la ultima evaluacion
							al sumarle 1 al recordcount no esta desplegando el resultado correcto--->
							<!---despues
							resultado<cfdump var="#vnResultado#"></br>
							divisoe<cf_dump var="#rsOtrosT.recordCount#"></br>--->
							<!---	<cfdump var="#vnResultado#"><br>
						<cfdump var="#vnResultadoOtros#"><br>						
						<cfdump var="#vnResultado#"><br>
						<cfdump var="#rsOtrosT#">--->
							<!---====== Se guardan TODAS las notas de TODOS los evaluadores, 
								cuando se cierra la relación de evaluación se hace la división correspondiente ========---->
                            <cfquery datasource="#session.DSN#">
                                update RHListaEvalDes
                                    set RHLEpromotros =  <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#vnResultado#">
                                where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
                                    and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                            </cfquery>
                        </cfif>
                        <cfif rsOtros.RHEDtipo EQ 'C' or rsOtros.RHEDtipo EQ 'S' or rsOtros.RHEDtipo EQ 'J'>
                            <!--- PROMEDIO DE LAS CALIFICACIONES DE JEFE-COMPAÑEROS-SUBORDINADOS --->
							<!---ljimenez		--->
							
							<cfquery name="rsTodos" datasource="#session.DSN#">
								select DEideval				 
								from RHEvaluadoresDes a
								where a.RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
									and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
									and a.RHEDtipo in ('C','S','J')
									and a.RHEEid in (	select PCUreferencia 
										from PortalCuestionarioU pcu
										where pcu.PCUestado=10
										and pcu.PCUreferencia = a.RHEEid
										and pcu.DEid = a.DEid
								)	
	            			</cfquery>
				
							<cfif rsTodos.recordCount GT 0>
								<cfloop query="rsTodos">
									<cfset TodosEvaluadores = rsTodos.DEideval >
									<cfset vnResultadoTodos = vnResultadoTodos + FuncObtieneResultado(vnDatos[2],vnDatos[1],vnDatos[4],rsTodos.DEideval)>	
								</cfloop>
							</cfif>
						<!---	
						<cfdump var="#vnResultadoT#"><br>
						<cfdump var="#vnResultadoTodos#"><br>
						
						<cfdump var="#vnResultadoT#"><br>
						<cfdump var="#rsTodos#">
						
							<cfquery name="x" datasource="#session.DSN#">
								select *
								from RHListaEvalDes
								where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
                    			and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
							</cfquery>
					
							vnResultado
							<cfdump var="#vnResultadoT#">
							--->
							<cfset  vnResultadoT  =  (vnResultadoT + vnResultadoTodos) / ( rsTodos.recordCount + 1)>
							<cfquery datasource="#session.DSN#">
                                update RHListaEvalDes
                                    set RHLEpromJCS = <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#vnResultadoT#">
                                where RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
                                    and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                            </cfquery>
	                        </cfif>
                    </cfif>				
                </cfif>

                <!--- Actualiza el estado de de la persona según los evaluadores --->
                <cfquery name="rsactEval" datasource="#session.DSN#">
                    update RHEvaluadoresDes 
                    set Estado = 1
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                      and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[5]#">					
                      and RHEEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
                </cfquery>
                
                
                <!---Actualiza el estado del cuestionario---->
                <cfquery datasource="#session.dsn#">
				    update PortalCuestionarioU
                    set PCUestado = 10,
						BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                    where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[1]#">
                        and PCUreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[2]#">
                        and DEideval = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vnDatos[5]#">					
                </cfquery>
            <cfelse>
				<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=1&errTitle=#MG_Advertencia_NoPuedeFinalizar#&ErrDet=<br>#URLEncodedFormat(MG_El_cuestionario_no_ha_sido_respondido_aun_por_lo_tanto_no_se_puede_finalizar)#" addtoken="no">
				<cfabort>
            </cfif>
         </cfif>   
	</cfloop>
	 <!---
	<cfdump var="hasta aqui">
     <cfabort>  
 --->
</cftransaction>
<cfoutput>
<cfif not isdefined('url.force')>
	<cfif form.Masiva eq 'SI'>
		<cflocation url='evaluar_des-lista2.cfm?RHEEid=#form.RHEEid#&PCid=#form.PCid#'>
	<cfelse>
		<cflocation url='evaluar_des-lista.cfm?tipo=#url.tipo#'>
	</cfif>
<cfelse>
	<center>Finalizacion del cuestionario exitosa!</center>
</cfif>
</cfoutput>
