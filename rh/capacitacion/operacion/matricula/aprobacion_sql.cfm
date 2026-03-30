<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_No_hay_Empleados_asignados_a_la_relacion"
	Default="No hay Empleados asignados a la relacion."
	returnvariable="MG_No_hay_Empleados_asignados_a_la_relacion"/> 
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MG_La_relación_de_matrícula_debe_estar_solicitada_o_en_revisión_para_poderse_aprobar_o_rechazar"
	Default="La relación de matrícula debe estar solicitada o en revisión para poderse aprobar o rechazar"
	returnvariable="MG_La_relación_de_matrícula_debe_estar_solicitada_o_en_revisión_para_poderse_aprobar_o_rechazar"/> 

<cfif not IsDefined('form.RHRCid')>
	<cflocation url="index.cfm">
</cfif>
<cfif IsDefined('form.Aprobar')>
	<cfset estado_siguiente = 40>
<cfelseif IsDefined('form.Rechazar')>
	<cfset estado_siguiente = 20>
<cfelse>
	<cflocation url="index.cfm">
</cfif>

<cfquery name="estado_actual" datasource="#session.dsn#">
	select RHRCestado, RHCid
	from RHRelacionCap
	where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif estado_actual.RecordCount is 0>
	<cflocation url="index.cfm">
</cfif>
<cfif estado_actual.RHRCestado neq estado_siguiente>
	<cfif not ListFind('10,30', estado_actual.RHRCestado)>
		<cf_throw message="#MG_La_relación_de_matrícula_debe_estar_solicitada_o_en_revisión_para_poderse_aprobar_o_rechazar#" errorcode="10050">
	</cfif>
	<cftransaction>
	
		<cfif estado_siguiente EQ 40>
			<!--- validar que haya suficiente cupo --->
			<cfquery name="rsYaMatriculados" datasource="#session.DSN#">
				select rc.DEid
				from RHRelacionCap e
					join RHDRelacionCap rc
						on rc.RHRCid = e.RHRCid
					join RHCursos c
						on c.RHCid = e.RHCid
				where rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				  and e.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				  and exists (
				  	select * from RHEmpleadoCurso ex
					where ex.DEid = rc.DEid
					  and ex.RHCid = e.RHCid)
			</cfquery>
	
			<cfif isdefined('rsYaMatriculados') and rsYaMatriculados.REcordCount>
				<cfset Lvar_CantYaMatriculados = rsYaMatriculados.RecordCount>
			<cfelse>
				<cfset Lvar_CantYaMatriculados = 0>
			</cfif>
			<cfset Lvar_YaMatr = ValueList(rsYaMatriculados.DEid)>
			
			<cfquery name="cuporequerido" datasource="#session.dsn#">
				select count(1) as cantidad
				from RHDRelacionCap 
				where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
			</cfquery>
			<cfif isdefined('cuporequerido') and cuporequerido.RecordCount>
				<cfset LvarCupoRequerido = cuporequerido.Cantidad>
			<cfelse>
				<cfset LvarCupoRequerido = 0>
			</cfif>
			<cfif LvarCupoRequerido EQ 0>
				<cf_throw message="#MG_No_hay_Empleados_asignados_a_la_relacion#" errorcode="10045">
			</cfif>
									
			<cfquery name="cupoocupado" datasource="#session.dsn#">
				select count(1) as cantidad
				from RHEmpleadoCurso
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>
			<cfif isdefined('cupoocupado') and cupoocupado.RecordCount>
				<cfset LvarCupoOcupado = cupoocupado.cantidad>
			<cfelse>
				<cfset LvarCupoOcupado = 0>
			</cfif>		
			<cfquery name="curso" datasource="#session.dsn#">
				select RHCcupo
				from RHCursos c
				inner join RHMateria m
					on c.Mcodigo= m.Mcodigo
				where c.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#estado_actual.RHCid#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			</cfquery>
			<cfif isdefined('curso') and curso.RecordCount>
				<cfset LvarRHCcupo = curso.RHCcupo>
			<cfelse>
				<cfset LvarRHCcupo = 0>
			</cfif>
			<cfset CantAmpliar = ((((LvarCupoRequerido - Lvar_CantYaMatriculados) + LvarCupoOcupado) - LvarRHCcupo) + LvarRHCcupo)>
			<cfif IsDefined('form.ampliar')>
				<cfif CantAmpliar GT 0 and CantAmpliar GT curso.RHCcupo>
					<cfquery name="selectRHMateria" datasource="#session.dsn#">
						select a.Mcodigo
						from RHMateria a, RHCursos b
						where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						  and a.Mcodigo = b.Mcodigo
						  and b.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#estado_actual.RHCid#">
					</cfquery>
					<cfquery datasource="#session.dsn#">
						update RHCursos
						set RHCcupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CantAmpliar#">
						from RHMateria a
						where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						  and a.Mcodigo = RHCursos.Mcodigo
						  and RHCursos.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#estado_actual.RHCid#">
					</cfquery>
				</cfif>
			</cfif>

			<!--- mandar email a los colaboradores. Lo hace antes de insertar en empleado curso para usar el mismo query y poder usar la ultima validacion --->
			<cfquery datasource="#session.dsn#" name="curso">
				select RHCcodigo as codigo, RHCnombre as nombre, RHCfdesde as inicio, RHCfhasta as fin ,horaini ,horafin,duracion ,lugar 
				from RHCursos c
				inner join RHMateria m
					on m.Mcodigo = c.Mcodigo
					and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#estado_actual.RHCid#">
			</cfquery>

			<cfset formato = 'dd/mm/yyyy' >
			
			<cfquery name="ParaElCorreo" datasource="#session.DSN#">
				select  c.RHCfdesde,
						de.DEemail,
						de.DEsexo,
					   {fn concat({fn concat({fn concat({fn concat(de.DEnombre , ' ' )}, de.DEapellido1 )}, ' ' )}, de.DEapellido2 )}  as empleado,
					    <cf_dbfunction name="datediff" args="#now()# , c.RHCfdesde" datasource="#session.DSN#"> as difFechas
				from RHRelacionCap e
				join RHDRelacionCap rc
					on rc.RHRCid = e.RHRCid
					and rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
	
				inner join DatosEmpleado de
				on rc.DEid=de.DEid
				and de.DEemail is not null
				inner join RHCursos c
				   on c.RHCid = e.RHCid
				where e.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				  and not exists (
				  	select * from RHEmpleadoCurso ex
					where ex.DEid = rc.DEid
					  and ex.RHCid = e.RHCid)
			</cfquery>

			<cfif ParaElCorreo.RecordCount gt 0 and ParaElCorreo.difFechas GTE 0>
				
				<cfset FromEmail = "capacitacion@soin.co.cr">
				<cfquery name="CuentaPortal"   datasource="#session.dsn#">
					Select valor
					from  <cf_dbdatabase table="PGlobal" datasource="asp">
					Where parametro='correo.cuenta'
				</cfquery>
				<cfif isdefined('CuentaPortal') and CuentaPortal.Recordcount GT 0>
					<cfset FromEmail = CuentaPortal.valor>
				</cfif>	
				
			    <cfloop query="ParaElCorreo">
					<cfsavecontent variable="_mail_body">
						<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
						<html>
						<head>
						<title>Desarrollo Humanos: Programación de Curso</title>
						<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
						<style type="text/css">
						<!--
						.style1 {
							font-size: 10px;
							font-family: "Times New Roman", Times, serif;
						}
						.style2 {
							font-family: Verdana, Arial, Helvetica, sans-serif;
							font-weight: bold;
							font-size: 14;
						}
						.style7 {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14; }
						.style8 {font-size: 14}
						-->
						</style>
						</head>
						
						<body>
						
						<cfoutput>
						  <table border="0" cellpadding="4" cellspacing="0" style="border:2px solid ##999999; ">
	                        <tr bgcolor="##999999">
	                          <td colspan="2" height="8"></td>
	                        </tr>
	                        <tr bgcolor="##003399">
	                          <td colspan="2" height="24"></td>
	                        </tr>
	                        <tr bgcolor="##999999">
	                          <td colspan="2"><strong>Desarrollo Humanos: Programación de Curso </strong> </td>
	                        </tr>
	                        <tr>
	                          <td width="70">&nbsp;</td>
	                          <td width="476">&nbsp;</td>
	                        </tr>
	                        <tr>
	                          <td><span class="style2">
	                            <cf_translate key="LB_De">De</cf_translate>
	                          </span></td>
	                          <td><span class="style7"> #Session.Enombre# </span></td>
	                        </tr>
	                        <tr>
	                          <td><span class="style7"><strong>
	                            <cf_translate key="LB_Para">Para</cf_translate>
	                          </strong></span></td>
	                          <td><span class="style7">
	                            <cfif #ParaElCorreo.DEsexo# eq 'M'>
	                              Sr
	                              <cfelse>
	                              (a)/ Srta
	                            </cfif>
	                            : #ParaElCorreo.empleado# </span></td>
	                        </tr>
	                        <tr>
	                          <td><span class="style8"></span></td>
	                          <td><span class="style8"></span></td>
	                        </tr>
	                        <tr>
	                          <td>&nbsp;</td>
	                          <td><span class="style7">Informaci&oacute;n sobre curso de capacitaci&oacute;n.</span></td>
	                        </tr>
	                        <tr>
	                          <td colspan="2">&nbsp;</td>
	                        </tr>
	                        <cfif not IsDefined("Request.MailArguments.Transition")>
	                          <tr>
	                            <td><span class="style8"></span></td>
	                            <td><span class="style7"> </span></td>
	                          </tr>
	                          <cfelse>
	                          <tr>
	                            <td><span class="style8"></span></td>
	                            <td><span class="style7">#Request.MailArguments.info#</span></td>
	                          </tr>
	                        </cfif>
		                        <tr>
	                          <td><span class="style8"></span></td>
	                          <td><span class="style8">
	                            <cfif #ParaElCorreo.DEsexo# eq 'M'>
	                              Sr
	                              <cfelse>
	                              (a)/ Srta
	                            </cfif>
	                            : #ParaElCorreo.empleado# <br>
	                            Se le ha programado el curso (#curso.codigo#-#curso.nombre#),<br>
								el cual tiene una duración total de  #curso.duracion# horas<br>
	                            y se estará llevando acabo del día <cf_locale name="date" value="#curso.inicio#"/> hasta el día <cf_locale name="date" value="#curso.fin#"/> <br>
	                            con un horario de #LSTimeFormat(curso.horaini, "hh:mm:tt")# a #LSTimeFormat(curso.horafin, "hh:mm:tt")#  <br>
								en el lugar de capacitación : #curso.lugar# </span></td>
	                        </tr>
	                      </table>
						</cfoutput>
	                     </body>
						</html>
					</cfsavecontent>
					
					<cfquery datasource="#session.DSN#">
						insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values (
							'#trim(FromEmail)#', 
							'#ParaElCorreo.DEemail#',
							'Desarrollo Humanos: Programación de Curso',
							'#preservesinglequotes(_mail_body)#',
							1
						)
					</cfquery>
				</cfloop>
			</cfif>
		</cfif>
		
			<cfquery datasource="#session.dsn#">
				insert into RHEmpleadoCurso (
					DEid, RHCid, Ecodigo, Mcodigo, 
					RHEMnotamin, RHEMnota, RHECtotempresa, RHECtotempleado, 
					idmoneda, RHECcobrar, RHEMestado,RHECfdesde,RHECfhasta,   
					BMfecha, BMUsucodigo)
				select
					rc.DEid, e.RHCid, e.Ecodigo, e.Mcodigo, 
					0 as RHEMnotamin, null as RHEMnota, c.RHECtotempresa, c.RHECtotempleado, 
					c.idmoneda, c.RHECcobrar, 0 as RHEMestado, 
					RHCfdesde,RHCfhasta,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				from RHRelacionCap e
					join RHDRelacionCap rc
						on rc.RHRCid = e.RHRCid
					join RHCursos c
						on c.RHCid = e.RHCid
				where rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				  and e.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
				  and not exists (
				  	select * from RHEmpleadoCurso ex
					where ex.DEid = rc.DEid
					  and ex.RHCid = e.RHCid)
			</cfquery>
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="LvarAM"/>
			 <cfif LvarAM eq 1>
			 	<cfquery name="rsUp" datasource="#session.dsn#">
					update RHEmpleadoCurso set RHECestado=50 
					where
					DEid in (	select rc.DEid
							from RHRelacionCap e
								join RHDRelacionCap rc
									on rc.RHRCid = e.RHRCid
								join RHCursos c
									on c.RHCid = e.RHCid
							where rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
							  and e.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">)
					and RHCid= (select distinct(e.RHCid)
							from RHRelacionCap e
								join RHDRelacionCap rc
									on rc.RHRCid = e.RHRCid
								join RHCursos c
									on c.RHCid = e.RHCid
							where rc.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
							  and e.RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">)
				</cfquery>
			 </cfif>
		
		
		<cfquery datasource="#session.dsn#">
			update RHRelacionCap
			set RHRCestado = <cfqueryparam cfsqltype="cf_sql_numeric" value="#estado_siguiente#">
			where RHRCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHRCid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		
	</cftransaction>
	<cfset params = ''>
	<cfif isdefined('Lvar_CantYaMatriculados')>
		<cfset params = params & '&YaMatriculados=#Lvar_CantYaMatriculados#'>
	</cfif>
	<cflocation url="index.cfm?RHRCid=#URLEncodedFormat(form.RHRCid)#&SEL=4&status=1&DEidMatr='#Lvar_YaMatr#'#params#">
</cfif>

<cflocation url="index.cfm?RHRCid=#URLEncodedFormat(form.RHRCid)#&SEL=4&status=1">
