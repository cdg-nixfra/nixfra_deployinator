# NixfraDeployinator

Deployment daemon for Nixfra.

Looks at an S3 paths to find what needs to be run. It copies that as a nix
closure, runs a migration if it exists, then does a rolling upgrade. It
uses libcluster to cluster and a global lock over the upgrade so that only
one system at the time gets upgraded.

Upgrades are staggered using global locks. Libcluster can be used to cluster
systems that need to be staggered.

Process:
* Remove from ALB (if configured)
* Take down old system
* Bring up new system
* Wait for health checks
* Add back to ALB

If health check not available in a minute or so,
* Bring up old system
* Wait for health checks
* Add back to ALB
