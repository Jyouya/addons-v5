local marksmanship = {
    ['Hot Shot'] = {
        jobs = {'cor', 'rng', 'thf', 'nin', 'war', 'drk'},
        requirements = {'cor', 'rng'}
    },
    ['Split Shot'] = {
        jobs = {'cor', 'rng', 'war', 'drk', 'thf', 'nin'},
        requirements = {'cor', 'rng'}
    },
    ['Sniper Shot'] = {
        jobs = {'cor', 'rng', 'war', 'drk', 'thf', 'nin'},
        requirements = {'cor', 'rng'}
    },
    ['Slug Shot'] = {
        jobs = {'cor', 'rng', 'war', 'drk', 'thf', 'nin'},
        requirements = {'cor', 'rng'}
    },
    ['Detonator'] = {jobs = {'cor', 'rng'}},
    ['Numbing Shot'] = {
        jobs = {'cor', 'rng', 'war', 'drk', 'thf', 'nin'},
        requirements = {'cor', 'rng'}
    },
    ['Last Stand'] = {jobs = {'cor', 'rng', 'thf'}},
    ['Wildfire'] = {jobs = {'cor', 'rng'}},
    ['Leaden Salute'] = {jobs = {'cor'}},
    ['Trueflight'] = {jobs = {'rng'}},
    ['Coronach'] = {jobs = {'rng'}}
}

local archery = {
    ['Flaming Arrow'] = {
        jobs = {'rng', 'sam', 'thf', 'war', 'rdm', 'nin'},
        requirements = {'rng'}
    },
    ['Piercing Arrow'] = {
        jobs = {'rng', 'sam', 'thf', 'war', 'rdm', 'nin'},
        requirements = {'rng'}
    },
    ['Dulling Arrow'] = {
        jobs = {'rng', 'sam', 'thf', 'war', 'rdm', 'nin'},
        requirements = {'rng'}
    },
    ['Sidewinder'] = {
        jobs = {'rng', 'sam', 'thf', 'war', 'rdm', 'nin'},
        requirements = {'rng'}
    },
    ['Blast Arrow'] = {jobs = {'rng'}},
    ['Arching Arrow'] = {jobs = {'rng'}},
    ['Empyreal ARrow'] = {
        jobs = {'rng', 'war', 'rdm', 'thf', 'pld', 'drk', 'bst', 'sam', 'nin'}
    },
    ['Refulgent Arrow'] = {
        jobs = {'rng', 'sam', 'thf', 'war', 'rdm', 'nin'},
        requirements = {'rng'}
    },
    ['Apex Arrow'] = {jobs = {'rng', 'sam'}},
    ['Namas Arrow'] = {jobs = {'rng', 'sam'}},
    ['Jishnu\'s Radiance'] = {jobs = {'rng'}}
}

return {marksmanship, archery}
