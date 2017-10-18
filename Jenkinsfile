#!groovy

@Library('github.com/red-panda-ci/jenkins-pipeline-library@develop') _

// Initialize global config
cfg = jplConfig('node-dind', 'backend' ,'', [hipchat: '', slack: '', email: 'redpandaci+node-dind@gmail.com'])

pipeline {
    agent none

    stages {
        stage ('Checkout') {
            agent { label 'docker' }
            steps  {
                jplCheckoutSCM(cfg)
            }
        }
        stage('Sonar analysis') {
            agent { label 'docker' }
            when { expression { (cfg.BRANCH_NAME == 'develop') || cfg.BRANCH_NAME.startsWith('PR-') } }
            steps {
                // jplSonarScanner(cfg)
                echo "Todo: Execute sonar scanner"
            }
        }
        stage ('Build') {
            agent { label 'docker' }
            steps  {
                sh 'bin/build.sh test; bin/build.sh latest'
            }
        }
        stage ('Test') {
            agent { label 'docker' }
            when { expression { (cfg.BRANCH_NAME == 'develop') || cfg.BRANCH_NAME.startsWith('PR-') } }
            steps  {
                sh 'bin/test.sh'
            }
        }
        stage ('Release confirm') {
            when { branch 'release/v*' }
            steps {
                jplPromoteBuild(cfg)
            }
        }
        stage ('Promote to master') {
            agent { label 'docker' }
            when { expression { cfg.BRANCH_NAME.startsWith('release/v') && cfg.promoteBuild } }
            steps {
                deleteDir()
                sh "git clone git@github.com:red-panda-ci/node-dind.git . -b ${cfg.BRANCH_NAME}"
                jplPromoteCode(cfg, cfg.BRANCH_NAME, 'master')
                build(job: 'master', wait: true)
            }
        }
        stage ('Release finish') {
            agent { label 'docker' }
            when { expression { cfg.BRANCH_NAME.startsWith('release/v') && cfg.promoteBuild } }
            steps {
                jplCloseRelease(cfg)
            }
        }
        stage ('PR Clean') {
            agent { label 'docker' }
            when { branch 'PR-*' }
            steps {
                deleteDir()
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        skipDefaultCheckout()
        timeout(time: 1, unit: 'DAYS')
    }
}
