# CHANGELOG

Todas as mudanças notáveis ​​neste projeto serão documentadas neste arquivo.

O formato é baseado em [Mantenha um Changelog](https://keepachangelog.com/pt-BR/1.1.0/)
e este projeto adere a [Versionamento Semântico](https://semver.org/lang/pt-BR/).

<!--
## [Unreleased] - yyyy-mm-dd

Here we write upgrading notes for brands. It's a team effort to make them as
straightforward as possible.

### Added

### Changed

### Fixed

### Breaking Changes
-->

## [1.0.0] - 2025-06-03

### Added
- Melhora a robustez do pipeline, evitando falhas por falta de credenciais ou recursos órfãos no state.

- Adiciona suporte ao evento manual (workflow_dispatch) para execução dos comandos apply e destroy via interface do GitHub Actions.

- Corrige os nomes das variáveis de ambiente para autenticação no backend Cloudflare R2, utilizando os secrets R2_ACCESS_KEY e R2_ACCESS_SECRET.

- Garante que todas as etapas do pipeline (init, fmt, validate, test, plan, apply, destroy) recebam as credenciais corretas.

- Adiciona variáveis de ambiente para integração com o provider MGC, utilizando secrets para maior segurança.


### Changed

- Workflow do GitHub Actions aprimorado: suporte a execuções manuais (apply/destroy), inclusão da branch develop e variáveis de ambiente padronizadas.
