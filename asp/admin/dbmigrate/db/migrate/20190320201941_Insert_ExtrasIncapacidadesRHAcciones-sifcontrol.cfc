<cfcomponent extends="asp.admin.dbmigrate.Migration" hint="Insert_ExtrasIncapacidadesRHAcciones">
  <cffunction name="up">
    <cfscript>
      execute("
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (0, N'Ninguno', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (1, N'Incapacidad Temporal', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (2, N'Valudacion Provisional Inicial', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (3, N'Valuacion Provisional', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (4, N'Definitiva', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (5, N'Recaida', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (6, N'Valuacion Post a la fecha de Alta', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (7, N'Revaluacion Provisional', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (8, N'Recaida sin alta medica', NULL)
              INSERT [dbo].[RHIconsecuencia] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (9, N'Revaluacion definitiva', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (0, N'Ninguno', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (1, N'Unica', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (2, N'Inicial', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (3, N'Subsecuente', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (4, N'Alta Medica o ST-2', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (5, N'Valuacion o ST-3', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (6, N'Defuncion o ST-3', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (7, N'Prenatal', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (8, N'Enlace', NULL)
              INSERT [dbo].[RHIcontrolincapacidad] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (9, N'Postnatal', NULL)
              INSERT [dbo].[RHItiporiesgo] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (0, N'Ninguno', NULL)
              INSERT [dbo].[RHItiporiesgo] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (1, N'Accidente de Trabajo', NULL)
              INSERT [dbo].[RHItiporiesgo] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (2, N'Accidente de Trayecto', NULL)
              INSERT [dbo].[RHItiporiesgo] ([RHIcodigo], [RHIdescripcion], [BMUsucodigo]) VALUES (3, N'Enfermedad Profesional', NULL)
              ");
    </cfscript>
  </cffunction>
  <cffunction name="down">
    <cfscript>
      execute('
              delete from RHIconsecuencia
              delete from RHIcontrolincapacidad
              delete from RHItiporiesgo
              ');
    </cfscript>
  </cffunction>
</cfcomponent>

		

		

		
